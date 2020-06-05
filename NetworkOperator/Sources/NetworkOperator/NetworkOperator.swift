import Foundation

public class NetworkOperator {
    private let session: URLSession
    public let queue: DispatchQueue
    public var enableTracing = false
    
    public init(configuration: URLSessionConfiguration = .default,
                queue: DispatchQueue = DispatchQueue(label: "Network operator")) {
        
        session = URLSession(configuration: configuration)
        self.queue = queue
    }
    
    public typealias Props = [UUID: () -> Request]
    
    public func process(props: Props) {
        var remainedActiveRequestsIds = Set(activeRequests.keys)
        
        for (id, request) in props {
            process(requestBuilder: request, for: id)
            remainedActiveRequestsIds.remove(id)
        }
        
        for cancelledRequestId in remainedActiveRequestsIds {
            cancel(requestId: cancelledRequestId)
        }
    }
    
    private var activeRequests: [UUID: (request: Request, task: URLSessionDataTask)] = [:]
    private var completedRequests: Set<UUID> = []
    
    private func process(requestBuilder: () -> Request, for id: UUID) {
        if completedRequests.contains(id) {
            return
        }
        
        if activeRequests.keys.contains(id) {
            // Request is still active - do nothing
        } else {
            // Create new task
            let request = requestBuilder()
            if (enableTracing) {
                print("Network:\t\t start \(request.request)")
                if let data = request.request.httpBody {
                    print("Network:\t\t body - \(String(data: data, encoding: .utf8)!)")
                }
            }
            
            let task = session.dataTask(with: request.request) { data, response, error in
                self.queue.async {
                    self.complete(id: id, data: data, response: response, error: error)
                }
            }
            
            activeRequests[id] = (request, task) // Store it to list of active tasks
            task.resume() // Begin task execution
        }
    }
    
    private func complete(id: UUID, data: Data?, response: URLResponse?, error: Error?) {
        guard let currentRequest = activeRequests[id] else {
            preconditionFailure("Request not found")
        }
        
        activeRequests[id] = nil
        completedRequests.insert(id)
        
        currentRequest.request.handler(data, response, error)
    }
    
    func cancel(requestId: UUID) {
        guard let (_, task) = activeRequests[requestId] else {
            preconditionFailure("Request not found")
        }

        task.cancel() // Stop task execution
    }
}
