import Foundation

public protocol Action {}

public struct UpdateUsername: Action {
    public init(username: String) {
        self.username = username
    }
    
    public let username: String
}

public struct UpdatePassword: Action {
    public init(password: String) {
        self.password = password
    }
    
    public let password: String
}

public struct Login: Action {
    public init() {}
}

public struct Logout: Action {
    public init() {}
}

public struct ReceiveToken: Action {
    public init(token: String) {
        self.token = token
    }

    public let token: String
}

public struct TokenRequestFailed: Action {
    public init() {}
}

public struct TokenValidated: Action {
    public init() {}
}

public struct InvalidCredentials: Action {
    public init() {}
}

public struct TokenValidationFailed: Action {
    public init() {}
}

public struct ReceiveSession: Action {
    public init(session: String) {
        self.session = session
    }
    
    public let session: String
}

public struct SessionRequestFailed: Action {
    public init() {}
}

public struct ReceiveMoviesPage: Action {
    public init(page: MoviesPage) {
        self.page = page
    }
    
    public let page: MoviesPage
}

public struct RequestNextMoviesPage: Action {
    public init() {}
}

public struct UpdateSearchQuery: Action {
    public init(query: String) {
        self.query = query
    }
    
    public let query: String
}

public struct ClearSearchQuery: Action {
    public init() {}
}

public struct ReceiveSearchPage: Action {
    public init(page: MoviesPage) {
        self.page = page
    }
    
    public let page: MoviesPage
}

public struct SearchRequestWasCancelled: Action {
    public init() {}
}

public struct RequestNextSearchPage: Action {
    public init() {}
}

public struct DidLoadPoster: Action {
    public init(movie: Movie.Id) {
        self.movie = movie
    }
    
    public let movie: Movie.Id
}

//public enum Action {
//    case updateUsername(String)
//    case updatePassword(String)
//
//    case login
//    case logout
//
//    case receiveToken(String)
//    case tokenRequestFailed
//
//    case tokenValidated
//    case invalidCredentials
//    case tokenValidationFailed
//
//    case receiveSession(String)
//    case sessionRequestFailed
//
//    case receiveMoviesPage(MoviesPage)
//    case requestNextMoviesPage
//
//    case updateSearchQuery(String)
//    case clearSearchQuery
//    case receiveSearchPage(MoviesPage)
//    case searchRequestWasCancelled
//    case requestNextSearchPage
//
//    case didLoadPoster(Movie.Id)
//}
