public struct MoviesPage: Equatable {
    public init(movies: [Movie], page: Int, totalPages: Int) {
        self.movies = movies
        self.page = page
        self.totalPages = totalPages
    }
    
    public let movies: [Movie]
    public let page: Int
    public let totalPages: Int
}
