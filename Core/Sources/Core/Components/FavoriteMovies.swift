import Foundation

public struct FavoriteMovies {
    public var favorites: Set<Movie.Id> = []
    
    mutating func reduce(_ action: Action) {
        switch action {
        case .addToFavorite(let id):
            favorites.insert(id)
        case .removeFromFavorites(let id):
            favorites.remove(id)
        default:
            break
        }
    }
}
