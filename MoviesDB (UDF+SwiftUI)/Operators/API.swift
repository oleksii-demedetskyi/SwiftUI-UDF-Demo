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
                    case .success(let result): return ReceiveToken(token: result.requestToken)
                default: return TokenRequestFailed()
                }
            }
        case .validation(let id):
            let body = Client.ValidateBody(
                username: state.loginForm.username,
                password: state.loginForm.password,
                requestToken: state.session.token!)
            fire(id, request: client.validateUser(body: body)) { response in
                switch response {
                case .success: return TokenValidated()
                case .unauthorized: return InvalidCredentials()
                case .failed: return TokenValidationFailed()
                default: preconditionFailure("Unexpected case")
                }
            }
        case .session(let id):
            let body = Client.CreateSessionBody(requestToken: state.session.token!)
            fire(id, request: client.createSession(body: body)) { response in
                switch response {
                    case .success(let result): return ReceiveSession(session: result.sessionId)
                default: return SessionRequestFailed()
                }
            }
        }
        
        if let id = state.moviesList.request {
            fire(id, request: client.getMovieList(page: state.moviesList.nextPage)) { response in
                guard case let .success(result) = response else {
                    preconditionFailure("Some error")
                }
                
                return ReceiveMoviesPage(page: result.asMoviesPage)
            }
        }
        
        if let id = state.searchResults.request, state.searchResults.canStartSearch {
            fire(id, request: client.searchMovie(
                by: state.searchResults.query,
                page: state.searchResults.nextPage)) { response in
                    switch response {
                        case .success(let result): return ReceiveSearchPage(page: result.asMoviesPage)
                    case .cancelled: return SearchRequestWasCancelled()
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
