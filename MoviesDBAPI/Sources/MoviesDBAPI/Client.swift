import Foundation

func update<T>(_ value: T, code: (inout T) -> ()) -> T {
    var value = value
    code(&value)
    return value
}


public struct Client {
    public init(baseURL: URL, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    public let baseURL: URL
    public let apiKey: String
    
    let encoder = update(JSONEncoder()) { encoder in
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    let decoder = update(JSONDecoder()) { decoder in
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func defaultHandler<Result: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Response<Result> {
        if let error = error as NSError? {
            switch (error.domain, error.code) {
            case (NSURLErrorDomain, NSURLErrorCancelled): return .cancelled
            default: return .failed
            }
        }
        
        guard let response = response as? HTTPURLResponse else {
            preconditionFailure("Response must be here if error is nil")
        }
        
        if response.statusCode == 401 {
            return .unauthorized
        }
        
        if response.statusCode != 200 {
            return .failed
        }
        
        guard let data = data else {
            preconditionFailure("Data need to be here")
        }
        
        do {
            let result = try decoder.decode(Result.self, from: data)
            return .success(result)
        } catch {
            print(error)
            return .failed
        }
    }
    
    func urlRequest(for path: String, with params: [URLQueryItem] = []) -> URLRequest {
        var url = baseURL
        url.appendPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        components.queryItems = params + [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        return URLRequest(url: components.url!)
    }
    
    func get(from path: String, with params: [URLQueryItem] = []) -> URLRequest {
        urlRequest(for: path, with: params)
    }
    
    func post<Body: Encodable>(_ body: Body, to path: String, with params: [URLQueryItem] = []) -> URLRequest {
        var request = self.urlRequest(for: path, with: params)
        
        request.httpMethod = "POST"
        request.httpBody = try! encoder.encode(body)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func request<Result: Decodable>(urlRequest: URLRequest) -> Request<Result> {
        Request(urlRequest: urlRequest, handler: defaultHandler)
    }
    
    public struct TokenResult: Decodable {
        public let success: Bool
        public let expiresAt: LongDate
        public let requestToken: String
    }
    
    public func getNewToken() -> Request<TokenResult> {
        Request(
            urlRequest: get(from: "authentication/token/new"),
            handler: defaultHandler
        )
    }
    
    public struct ValidateBody: Encodable {
        public init(username: String, password: String, requestToken: String) {
            self.username = username
            self.password = password
            self.requestToken = requestToken
        }
        
        public let username: String
        public let password: String
        public let requestToken: String
    }
    
    public func validateUser(body: ValidateBody) -> Request<TokenResult> {
        request(urlRequest: post(body, to: "authentication/token/validate_with_login"))
    }
    
    public struct SessionResult: Decodable {
        public let success: Bool
        public let sessionId: String
    }
    
    public struct CreateSessionBody: Encodable {
        public init(requestToken: String) {
            self.requestToken = requestToken
        }
        
        public let requestToken: String
    }
    
    public func createSession(body: CreateSessionBody) -> Request<SessionResult> {
        request(urlRequest: post(body, to: "authentication/session/new"))
    }
    
    public struct MovieListResult: Decodable {
        public let page: Int
        public let totalPages: Int
        public let totalResults: Int
        public let results: [Result]
        
        public struct Result: Decodable {
            public let id: Int
            public let title: String
            public let overview: String
            public let posterPath: String?
        }
    }
    
    public func getMovieList(page: Int) -> Request<MovieListResult> {
        let params = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
            
        return request(urlRequest: get(from: "discover/movie", with: params))
    }
    
    public func getMovie(with id: Int) -> Request<MovieListResult.Result> {
        request(urlRequest: get(from: "movie/\(id)"))
    }
    
    public func searchMovie(by query: String, page: Int) -> Request<MovieListResult> {
        let params = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "query", value: query)
        ]
        
        return request(urlRequest: get(from: "search/movie", with: params))
    }
    
    public struct UpdateFavoriteResult: Decodable {
        public let statusCode: Int
        public let statusMessage: String
    }
    
    struct UpdateFavoriteBody: Encodable {
        let mediaType: String
        let mediaId: Int
        let favorite: Bool
    }
    
    public func updateFavorite(id: Int, isFavorite: Bool, sessionId: String) -> Request<UpdateFavoriteResult> {
        let body = UpdateFavoriteBody(
            mediaType: "movie",
            mediaId: id,
            favorite: isFavorite)
        
        let params = [
            URLQueryItem(name: "session_id", value: sessionId)
        ]
        
        return request(urlRequest: post(body, to: "account/_/favorite", with: params))
    }
    
    public func favoriteMovies(sessionId: String) -> Request<MovieListResult> {
        let params = [
            URLQueryItem(name: "session_id", value: sessionId)
        ]
        return request(urlRequest: get(from: "account/_/favorite/movies", with: params))
    }
}
