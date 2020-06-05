import Foundation

public enum Action {
    case updateUsername(String)
    case updatePassword(String)
    
    case login
    case logout
    
    case receiveToken(String)
    case tokenRequestFailed
    
    case tokenValidated
    case invalidCredentials
    case tokenValidationFailed
    
    case receiveSession(String)
    case sessionRequestFailed
    
    case receiveMoviesPage(MoviesPage)
    case requestNextMoviesPage
    
    case updateSearchQuery(String)
    case clearSearchQuery
    case receiveSearchPage(MoviesPage)
    case searchRequestWasCancelled
    case requestNextSearchPage
    
    case didLoadPoster(Movie.Id)
    
    case addToFavorite(Movie.Id)
    case removeFromFavorites(Movie.Id)
    
    case displayMovieDetails(Movie.Id)
}
