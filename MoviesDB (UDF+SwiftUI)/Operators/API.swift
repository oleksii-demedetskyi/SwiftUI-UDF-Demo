import NetworkOperator
import Dispatch
import Core
import MoviesDBAPI
import Foundation

struct NetworkDriver {
    let store: Store
    let client: Client
    let `operator`: NetworkOperator
    
    var asObserver: Observer {
        Observer(queue: self.operator.queue) { state in
            self.observe(state: state)
            return .active
        }
    }
    
    func observe(state: AppState) {
        var requests = [NetworkOperator.Request]()
        
        defer {
            self.operator.process(props: requests)
        }
        
        func fire<Data: Decodable>(
            _ id: UUID,
            request: Client.Request<Data>,
            onComplete: @escaping (Client.Response<Data>) -> Action) {
            
            requests.append(NetworkOperator.Request(
                id: id,
                request: request.urlRequest,
                handler: { data, response, error in
                    let result = request.handler(data, response, error)
                    let action = onComplete(result)
                    self.store.dispatch(action: action)
            }))
        }
        
        switch state.loginFlow {
        case .none: break
        case .token(let id):
            fire(id, request: client.getNewToken()) { response in
                switch response {
                case .success(let result): return .receiveToken(result.requestToken)
                default: return .tokenRequestFailed
                }
            }
        case .validation(let id):
            let body = Client.ValidateBody(
                username: state.loginForm.username,
                password: state.loginForm.password,
                requestToken: state.session.token!)
            fire(id, request: client.validateUser(body: body)) { response in
                switch response {
                case .success: return .tokenValidated
                case .unauthorized: return .invalidCredentials
                case .failed: return .tokenValidationFailed
                default: preconditionFailure("Unexpected case")
                }
            }
        case .session(let id):
            let body = Client.CreateSessionBody(requestToken: state.session.token!)
            fire(id, request: client.createSession(body: body)) { response in
                switch response {
                case .success(let result): return .receiveSession(result.sessionId)
                default: return .sessionRequestFailed
                }
            }
        }
        
        if let id = state.moviesList.request {
            fire(id, request: client.getMovieList(page: state.moviesList.nextPage)) { response in
                guard case let .success(result) = response else {
                    preconditionFailure("Some error")
                }
                
                return .receiveMoviesPage(result.asMoviesPage)
            }
        }
        
        if let id = state.searchResults.request, state.searchResults.canStartSearch {
            fire(id, request: client.searchMovie(
                by: state.searchResults.query,
                page: state.searchResults.nextPage)) { response in
                    switch response {
                    case .success(let result): return .receiveSearchPage(result.asMoviesPage)
                    case .cancelled: return .searchRequestWasCancelled
                    default : preconditionFailure("Some error")
                    }
            }
        }
    }
}

extension Client.MovieListResult.Result {
    var asCoreMovie: Core.Movie {
        Movie(
            id: Movie.Id(value: id),
            title: title,
            description: overview,
            posterPath: posterPath
        )
    }
}

extension Client.MovieListResult {
    var asMoviesPage: MoviesPage {
        MoviesPage(movies: results.map(\.asCoreMovie), page: page, totalPages: totalPages)
    }
}
