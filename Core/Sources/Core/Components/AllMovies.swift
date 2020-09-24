public struct AllMovies {
    public var byId: [Movie.Id: Movie] = [:]
    
    mutating func reduce(_ action: Action) {
        switch action {
            case let action as ReceiveSearchPage:
                for movie in action.page.movies {
                    byId[movie.id] = movie
                }
                
            case let action as ReceiveMoviesPage:
                for movie in action.page.movies {
                    byId[movie.id] = movie
                }
                
            default: break
        }
    }
}
