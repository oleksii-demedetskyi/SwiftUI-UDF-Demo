public struct Graph {
    public init(state: AppState, dispatch: @escaping (Action) -> ()) {
        self.state = state
        self.dispatch = dispatch
    }
    
    let state: AppState
    let dispatch: (Action) -> ()
}
