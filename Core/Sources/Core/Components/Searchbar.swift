public struct Searchbar {
    public var query: String = ""
    public var request: UUID?
    
    public var results: [Movie.Id] = []
    public var currentPage: Int = 0
    public var totalPages: Int = 1
    
    
    public var canClearSearch: Bool {
        query.count > 0
    }
    
    public var canStartSearch: Bool {
        query.count > 2
    }
    
    public var nextPage: Int {
        currentPage + 1
    }
    
    public var hasNextPage: Bool {
        currentPage < totalPages
    }
    
    public var canRequestNextPage: Bool {
        canStartSearch && hasNextPage && request == nil
    }
    
    mutating func reduce(_ action: Action) {
        switch action {
            
        case .updateSearchQuery(let value):
            self = Searchbar()
            query = value
            
            if canStartSearch { request = UUID() }
            
        case .clearSearchQuery:
            self = Searchbar()
            
        case .receiveSearchPage(let page):
            results += page.movies.map(\.id)
            currentPage = page.page
            totalPages = page.totalPages
            
        case .requestNextSearchPage where canRequestNextPage:
            request = UUID()
            
        default: break
        }
    }
}
