extension Graph {
    func page(hasNextPage: Bool, loadNextPage: Action) -> PageNode {
        return PageNode(
            graph: self,
            loadNextPageAction: loadNextPage,
            hasNextPage: hasNextPage)
    }
}


public struct PageNode {
    let graph: Graph
    let loadNextPageAction: Action
    public let hasNextPage: Bool
    
    public func loadNextPage() {
        if hasNextPage {
            graph.dispatch(loadNextPageAction)
        }
    }
}
