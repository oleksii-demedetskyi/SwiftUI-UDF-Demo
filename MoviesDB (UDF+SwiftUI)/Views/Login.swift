import SwiftUI

struct Login: View {
    @Binding var username: String
    @Binding var password: String
    
    let loginAction: LoginAction
    let loginProgress: LoginProgress
    
    var body: some View {
        VStack {
            Text("Welcome to movies database")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 30)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 30)
            
            Button(action: onLogin) { Text("Login") }
                .disabled(loginAction.isDisabled)
                .padding(.top, 30)
            
            if (loginProgress != .none) {
                Text(loginProgress.rawValue)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
    
    func onLogin() {
        if case .available(let action) = loginAction {
            action()
        }
    }
    
    enum LoginAction {
        case available(Command)
        case unavailable
        
        var isDisabled: Bool {
            if case .available = self { return false }
            else { return true }
        }
    }
    
    enum LoginProgress: String, Equatable {
        case none = ""
        case active = "Checking your credentials..."
        case unauthorized = "Incorrect credentials!"
        case failed = "Cannot complete operation"
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: Login {
        Login(
            username: State(initialValue: "").projectedValue,
            password: State(initialValue: "").projectedValue,
            loginAction: .unavailable,
            loginProgress: .failed
        )
    }
}
