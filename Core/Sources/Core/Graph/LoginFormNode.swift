extension Graph {
    public var loginForm: LoginFormNode { LoginFormNode(graph: self) }
}

public struct LoginFormNode {
    let graph: Graph
    
    public var username: String {
        get { graph.state.loginForm.username }
        nonmutating set { graph.dispatch(UpdateUsername(username: newValue))}
    }
    
    public var password: String {
        get { graph.state.loginForm.password }
        nonmutating set { graph.dispatch(UpdatePassword(password: newValue ))}
    }
    
    public var progress: LoginStatus { graph.state.loginStatus }
    
    public var isCredentialsOK: Bool { graph.state.loginForm.isCredentialsOk }
    
    public func login() {
        graph.dispatch(Login())
    }
}
