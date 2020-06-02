extension AppState {
    public var isLoggedIn: Bool {
        session.token != nil && session.session != nil
    }
}
