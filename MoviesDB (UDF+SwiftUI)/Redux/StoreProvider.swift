import SwiftUI
import Core

struct StoreProvider<Content: View>: View {
    let store: Store
    let content: () -> Content
    
    var body: some View {
        content().environmentObject(EnvironmentStore(store: store))
    }
}
