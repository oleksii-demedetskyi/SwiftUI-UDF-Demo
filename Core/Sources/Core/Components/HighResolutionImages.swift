import Foundation

public struct HighResolutionImages {
    public var ids: Set<Movie.Id> = []
    
    mutating func reduce(_ action: Action) {
        switch action {
        case .displayMovieDetails(let id):
            ids.insert(id)
        default:
            break
        }
    }
}
