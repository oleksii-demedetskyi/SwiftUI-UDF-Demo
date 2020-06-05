import Foundation

extension NetworkOperator {
    public struct Request {
        public init(request: URLRequest,
                    handler: @escaping (Data?, URLResponse?, Error?) -> ()) {
            self.request = request
            self.handler = handler
        }
        
        public let request: URLRequest
        public let handler: (Data?, URLResponse?, Error?) -> ()
    }
}
