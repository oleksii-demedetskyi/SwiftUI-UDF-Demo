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
    
    func observe(state: AppState) {
        var requests: NetworkOperator.Props = [:]
        
        defer {
            network.process(props: requests)
        }
        
        let movies = state.allMovies.byId.keys
        
        for movie in movies where !ids.keys.contains(movie) {
            // Generate uuids for request mapping
            let id = UUID()
            ids[movie] = id
            
            guard let poster = state.allMovies.byId[movie]!.posterPath else {
                continue
            }
            
            requests[id] = {
                let url = URL(string: "https://image.tmdb.org/t/p/w92")!
                    .appendingPathComponent(poster)
                
                return NetworkOperator.Request(
                    request: URLRequest(url: url),
                    handler: self.handler(movieId: movie)
                )
            }
        }
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
