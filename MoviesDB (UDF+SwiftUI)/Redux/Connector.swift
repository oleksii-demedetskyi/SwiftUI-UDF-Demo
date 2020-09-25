import SwiftUI
import Core

protocol Connector: View {
    associatedtype Content: View
    func map(graph: Graph) -> Content
}

extension Connector {
    var body: some View {
        Connected<Content>(map: self.map)
    }
}

fileprivate struct Connected<V: View>: View {
    @EnvironmentObject var store: EnvironmentStore
    
    let map: (Graph) -> V
    
    var body: V {
        map(store.graph)
    }
}
