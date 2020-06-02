public enum LoginFlow {
    case none
    case token(UUID)
    case validation(UUID)
    case session(UUID)
    
    init() { self = .none }
    
    mutating func reduce(_ action: Action) {
        switch action {
            
        case .login: self = .token(UUID())
        case .receiveToken: self = .validation(UUID())
        case .tokenValidated: self = .session(UUID())
        case .tokenRequestFailed: self = .none
        case .invalidCredentials: self = .none
        case .tokenValidationFailed: self = .none
        case .receiveSession: self = .none
        case .sessionRequestFailed: self = .none
        
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
            
        case .login: self = .inProgress
        case .tokenRequestFailed: self = .failed
        case .invalidCredentials: self = .invalidCredentials
        case .tokenValidationFailed: self = .failed
        case .receiveSession: self = .success
        case .sessionRequestFailed: self = .failed
        case .logout: self = .none
            
        default: break }
    }
}
