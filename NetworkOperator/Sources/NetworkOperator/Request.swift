import Foundation

extension NetworkOperator {
    public struct Request {
        public init(id: UUID,
                    request: URLRequest,
                    handler: @escaping (Data?, URLResponse?, Error?) -> ()) {
            self.id = id
            self.request = request
            self.handler = handler
        }
        
        public let id: UUID
        public let request: URLRequest
        public let handler: (Data?, URLResponse?, Error?) -> ()
    }
}
