import Dispatch
import NetworkOperator
import Foundation
import Core
import UIKit

class ImageLoader {
    internal init(store: Store, cache: ImageCache) {
        self.store = store
        self.cache = cache
        
        self.network.enableTracing = true
    }
    
    let network = NetworkOperator()
    let store: Store
    let cache: ImageCache
    
    var asObserver: Observer {
        Observer(queue: network.queue,
                 observe: { state in
                    self.observe(state: state)
                    return .active
        })
    }
    
    private var ids: [Movie.Id: UUID] = [:]
    private var highResIds: [Movie.Id: UUID] = [:]
    
    func url(for poster: String) -> URL {
        URL(string: "https://image.tmdb.org/t/p/w92")!.appendingPathComponent(poster)
    }
    
    func highResolutionUrl(for poster: String) -> URL {
        URL(string: "https://image.tmdb.org/t/p/w500")!.appendingPathComponent(poster)
    }
    
    func observe(state: AppState) {
        let movies = state.allMovies.byId.keys
        
        // Generate uuids for request mapping
        for movie in movies where !ids.keys.contains(movie) {
            ids[movie] = UUID()
        }
        
        var requests: [NetworkOperator.Request] = movies.compactMap { movieId in
            let uuid = ids[movieId]!
            
            guard let poster = state.allMovies.byId[movieId]!.posterPath else {
                return nil
            }
            
            let urlRequest = URLRequest(
                url: url(for: poster)
            )
            
            let operatorRequest = NetworkOperator.Request(
                id: uuid,
                request: urlRequest,
                handler: handler(movieId: movieId)
            )
            
            return operatorRequest
        }
        
        for movieId in state.highResolutionImages.ids where !highResIds.keys.contains(movieId) {
            let uuid = UUID()
            highResIds[movieId] = uuid
            
            guard let poster = state.allMovies.byId[movieId]!.posterPath else {
                continue
            }
            
            let urlRequest = URLRequest(
                url: highResolutionUrl(for: poster)
            )
            
            let request = NetworkOperator.Request(
                id: uuid,
                request: urlRequest,
                handler: handler(movieId: movieId)
            )
            
            requests.append(request)
        }
        
        network.process(props: requests)
    }
    
    func handler(movieId: Movie.Id) -> (Data?, URLResponse?, Error?) -> () {
        return { data, response, error in
            guard let data = data else {
                preconditionFailure("No data in reponse")
            }
            
            guard let image = UIImage(data: data) else {
                preconditionFailure("Cannot read image")
            }
            
            DispatchQueue.main.sync {
                self.cache.store(poster: image, for: movieId)
            }
            
            self.store.dispatch(action: .didLoadPoster(movieId))
        }
    }
}
