public struct LoginForm {
    public var username: String = ""
    public var password: String = ""
    
    public var isCredentialsOk: Bool {
        username.count > 2 && password.count > 2
    }
    
    mutating func reduce(_ action: Action) {
        switch action {
            case let action as UpdateUsername: username = action.username
            case let action as UpdatePassword: password = action.password
            case is Logout: self = Self()
            default: break
        }
    }
}
