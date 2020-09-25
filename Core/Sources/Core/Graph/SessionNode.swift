extension Graph {
    public var session: SessionNode { SessionNode(graph: self) }
}

public struct SessionNode {
    let graph: Graph
    
    public func logout() { graph.dispatch(Logout()) }
    
    public var isActive: Bool { graph.state.session.token != nil && graph.state.session.session != nil }
}
