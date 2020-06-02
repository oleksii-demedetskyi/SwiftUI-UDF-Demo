import Foundation

extension Client {
    public struct Request<Result: Decodable> {
        
        public init(urlRequest: URLRequest,
                    handler: @escaping (Data?, URLResponse?, Error?) -> Client.Response<Result>) {
            self.urlRequest = urlRequest
            self.handler = handler
        }
        
        public let urlRequest: URLRequest
        public let handler: (Data?, URLResponse?, Error?) -> Response<Result>
    }
}
