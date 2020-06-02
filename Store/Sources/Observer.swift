import Dispatch

public class Observer<State>: Hashable {
    public static func == (lhs: Observer<State>, rhs: Observer<State>) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
    
    public enum Status {
        case active
        case postponed(Int)
        case dead
    }
    
    let queue: DispatchQueue
    let observe: (State) -> Status
    
    public init(queue: DispatchQueue, observe: @escaping (State) -> Status) {
        self.queue = queue
        self.observe = observe
    }
}
