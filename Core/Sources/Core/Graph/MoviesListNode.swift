extension Graph {
    public var moviesList: MoviesListNode { MoviesListNode(graph: self) }
}

public struct MoviesListNode {
    let graph: Graph
    var entity: MoviesList { graph.state.moviesList }
    
    public var movies: [MovieNode] { entity.ids.map(graph.movie(id:)) }
    public var ids: [Movie.Id] { entity.ids }
    public var page: PageNode { graph.page(
        hasNextPage: entity.canRequestNextPage,
        loadNextPage: RequestNextMoviesPage())}
}
