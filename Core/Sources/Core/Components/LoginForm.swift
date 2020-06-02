public struct LoginForm {
    public var username: String = ""
    public var password: String = ""
    
    public var isCredentialsOk: Bool {
        username.count > 2 && password.count > 2
    }
    
    mutating func reduce(_ action: Action) {
        switch action {
        case .updateUsername(let value): username = value
        case .updatePassword(let value): password = value
        case .logout: self = LoginForm()
        default: break
        }
    }
}
