extension Graph {
    public var search: SearchNode { SearchNode(graph: self) }
}

public struct SearchNode {
    let graph: Graph
    
    public var query: String {
        get { graph.state.searchResults.query }
        nonmutating set { graph.dispatch(UpdateSearchQuery(query: newValue)) }
    }
    
    public var results: [MovieNode] { ids.map(graph.movie)}
    public var ids: [Movie.Id] { graph.state.searchResults.results }
    public var page: PageNode { graph.page(
        hasNextPage: graph.state.searchResults.canRequestNextPage,
        loadNextPage: RequestNextSearchPage()) }
    
    public var canClear: Bool { graph.state.searchResults.canClearSearch }
    
    public func clear() { graph.dispatch(ClearSearchQuery()) }
}
