public struct Movie: Equatable {
    public struct Id: Hashable {
        public init(value: Int) {
            self.value = value
        }
        
        public let value: Int
    }
    
    public init(id: Id, title: String, description: String, posterPath: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.posterPath = posterPath
    }
    
    public let id: Id
    public let title: String
    public let description: String
    public let posterPath: String?
}

