public struct Session {
    public var token: String?
    public var session: String?
    
    mutating func reduce(_ action: Action) {
        switch action {
        case .receiveToken(let value): token = value
        case .receiveSession(let value): session = value
        case .logout: self = Session()

        default: break
        }
    }
}
