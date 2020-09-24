public struct Session {
    public var token: String?
    public var session: String?
    
    mutating func reduce(_ action: Action) {
        switch action {
            case let action as ReceiveToken: token = action.token
            case let action as ReceiveSession: session = action.session
            case is Logout: self = Session()
                
            default: break
        }
    }
}
