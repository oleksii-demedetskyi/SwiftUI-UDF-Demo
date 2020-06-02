import SwiftUI
import Core

protocol Connector: View {
    associatedtype Content: View
    func map(state: AppState, store: EnvironmentStore) -> Content
}

extension Connector {
    var body: some View {
        Connected<Content>(map: map)
    }
}

fileprivate struct Connected<V: View>: View {
    @EnvironmentObject var store: EnvironmentStore
    
    let map: (_ state: AppState, _ store: EnvironmentStore) -> V
    
    var body: V {
        map(store.state, store)
    }
}
