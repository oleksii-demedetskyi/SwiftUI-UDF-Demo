
public struct AppState {
    public var loginForm = LoginForm()
    public var loginFlow = LoginFlow()
    public var loginStatus = LoginStatus()
    public var session = Session()
    public var allMovies = AllMovies()
    public var moviesList = MoviesList()
    public var searchResults = Searchbar()
    public var favoriteMovies = FavoriteMovies()
    
    public mutating func reduce(_ action: Action) {
        loginForm.reduce(action)
        loginFlow.reduce(action)
        loginStatus.reduce(action)
        session.reduce(action)
        allMovies.reduce(action)
        moviesList.reduce(action)
        searchResults.reduce(action)
        favoriteMovies.reduce(action)
    }
    
    public init() {}
}
