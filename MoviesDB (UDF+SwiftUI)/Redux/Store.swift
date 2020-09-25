import SwiftUI

class EnvironmentStore: ObservableObject {
    @Published private (set) var graph: Graph
    
    let store: Store
    
    init(store: Store) {
        self.store = store
        self.graph = Graph(state: store.state, dispatch: store.dispatch(action:))
        
        store.subscribe(observer: asObserver)
    }
    
    private var asObserver: Observer {
        Observer(queue: .main) { state in
            self.graph = Graph(state: state, dispatch: self.store.dispatch(action:))
            return .active
        }
    }
}


