public struct AllMovies {
    public var byId: [Movie.Id: Movie] = [:]
    
    mutating func reduce(_ action: Action) {
        switch action {
            
        case .receiveSearchPage(let page),
             .receiveMoviesPage(let page):
            for movie in page.movies {
                byId[movie.id] = movie
            }
            
            
        default: break
        }
    }
}
