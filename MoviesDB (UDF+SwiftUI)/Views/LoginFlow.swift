import SwiftUI

struct LoginFlow<L: View, C: View>: View {
    let isLoggedIn: Bool
    
    let login: () -> L
    let content: () -> C
    
    var body: some View {
        ZStack {
            if (isLoggedIn) {
                content()
            } else {
                login()
            }
        }
    }
}

struct LoginFlow_Previews: PreviewProvider {
    static var previews: some View {
        LoginFlow(
            isLoggedIn: false,
            login: { Login_Previews.previews },
            content: { MoviesList_Previews.previews }
        )
    }
}

struct LoginFlowConnector: Connector {
    func map(state: AppState, store: EnvironmentStore) -> some View {
        LoginFlow(
            isLoggedIn: state.isLoggedIn,
            login: { LoginConnector() },
            content: { MoviesListConnector() }
        )
    }
}

