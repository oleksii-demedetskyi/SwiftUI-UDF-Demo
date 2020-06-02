import Dispatch

public class Store<State, Action> {
    public typealias Reducer = (inout State, Action) -> ()
    private let queue = DispatchQueue(label: "Store queue", qos: .userInitiated)
    
    public init(initial state: State, reducer: @escaping Reducer) {
        self.reducer = reducer
        self.state = state
    }
    
    let reducer: Reducer
    public private(set) var state: State
    
    public func dispatch(action: Action) {
        queue.async {
            self.reducer(&self.state, action)
            self.observers.forEach(self.notify)
        }
    }
    
    private var observers: Set<Observer<State>> = []
    
    public func subscribe(observer: Observer<State>) {
        queue.async {
            self.observers.insert(observer)
            self.notify(observer)
        }
    }
    
    /// WARNING: This method must be called on internal queue
    private func notify(_ observer: Observer<State>) {
        let status = observer.queue.sync {
            observer.observe(state)
        }
        
        if case .dead = status {
            observers.remove(observer)
        }
    }
}
