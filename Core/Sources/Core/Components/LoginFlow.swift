public enum LoginFlow {
    case none
    case token(UUID)
    case validation(UUID)
    case session(UUID)
    
    init() { self = .none }
    
    mutating func reduce(_ action: Action) {
        switch action {
            
        case is Login: self = .token(UUID())
        case is ReceiveToken: self = .validation(UUID())
        case is TokenValidated: self = .session(UUID())
        case is TokenRequestFailed: self = .none
        case is InvalidCredentials: self = .none
        case is TokenValidationFailed: self = .none
        case is ReceiveSession: self = .none
        case is SessionRequestFailed: self = .none
        
        default: break
        }
    }
}

public enum LoginStatus {
    case none
    case inProgress
    case invalidCredentials
    case success
    case failed
    
    init() { self = .none }
    
    mutating func reduce(_ action: Action) {
        switch action {
            
        case is Login: self = .inProgress
        case is TokenRequestFailed: self = .failed
        case is InvalidCredentials: self = .invalidCredentials
        case is TokenValidationFailed: self = .failed
        case is ReceiveSession: self = .success
        case is SessionRequestFailed: self = .failed
        case is Logout: self = .none
            
        default: break }
    }
}
