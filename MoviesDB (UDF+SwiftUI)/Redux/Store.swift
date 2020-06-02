import SwiftUI

class EnvironmentStore: ObservableObject {
    let store: Store
    
    @Published private (set) var state: AppState
    
    init(store: Store) {
        self.store = store
        self.state = store.state
        
        store.subscribe(observer: asObserver)
    }
    
    func dispatch(_ action: Action) {
        store.dispatch(action: action)
    }
    
    private var asObserver: Observer {
        Observer(queue: .main) { state in
            self.state = state
            return .active
        }
    }
    
    func bind(_ action: Action) -> Command {
        return {
            self.dispatch(action)
        }
    }
    
    func bind<T>(_ action: @escaping (T) -> Action) -> CommandWith<T> {
        return { value in
            self.dispatch(action(value))
        }
    }
}


