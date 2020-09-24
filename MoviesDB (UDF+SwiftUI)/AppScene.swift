import SwiftUI
import NetworkOperator
import MoviesDBAPI
import Core

@main
struct MyMovies: App {
    @Environment(\.imageCache) var imageCache
    
    let store = Store(initial: AppState()) { state, action in
        print("Reduce\t\t\t", action)
        state.reduce(action)
    }
    
    let client = Client(
        baseURL: URL(string: "https://api.themoviedb.org/3/")!,
        apiKey: "37347f4b1c7ebd6c41b60e3e539d4a60"
    )
    
    let networkOperator = NetworkOperator()
    
    init() {
        networkOperator.enableTracing = true
        
        let networkDriver = NetworkDriver(store: store, client: client, operator: networkOperator)
        let imageLoader = ImageLoader(store: store, cache: imageCache)
        
        store.subscribe(observer: networkDriver.asObserver)
        store.subscribe(observer: imageLoader.asObserver)
        
        store.dispatch(action: .updateUsername("dalog"))
        store.dispatch(action: .updatePassword("myhxoq-rummit-4tEwho"))
    }
    
    var body: some Scene {
        WindowGroup {
            StoreProvider(store: store) {
                Text("???")
            }
        }
    }
}
