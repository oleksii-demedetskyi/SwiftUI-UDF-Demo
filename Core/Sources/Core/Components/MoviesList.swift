public struct MoviesList {
    public var ids: [Movie.Id] = []
    public var currentPage = 0
    public var totalPages = 1
    public var request: UUID? = UUID()
    
    public var hasMorePages: Bool {
        currentPage < totalPages
    }
    
    public var canRequestNextPage: Bool {
        hasMorePages && request == nil
    }
    
    public var nextPage: Int {
        currentPage + 1
    }
    
    mutating func reduce(_ action: Action) {
        switch action {
            
        case let action as ReceiveMoviesPage:
            request = nil
            ids += action.page.movies.map(\.id)
            currentPage = action.page.page
            totalPages = action.page.totalPages
            
        case is RequestNextMoviesPage where request == nil:
            request = UUID()
            
        default: break
        }
    }
}
