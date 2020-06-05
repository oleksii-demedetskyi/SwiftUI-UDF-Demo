import SwiftUI
import Core

struct MoviesList<MovieRow: View, Searchbar: View, MovieDetails: View>: View {
    let logout: Command
    let ids: [Movie.Id]
    let loadNextPage: Command?
    
    let row: (Movie.Id) -> MovieRow
    let searchbar: () -> Searchbar
    let movieDetails: (Movie.Id) -> MovieDetails
    
    var body: some View {
        NavigationView {
            List {
                searchbar()
                
                ForEach(ids, id:\.self) { id in
                    NavigationLink(
                        destination: self.movieDetails(id),
                        label: { self.row(id) }
                    )
                }
                
                if loadNextPage != nil {
                    Text("Loading...").onAppear(perform: loadNextPage)
                }
            }
            .navigationBarTitle("All movies")
            .navigationBarItems(trailing: Button(action: logout) {
                Text("Logout")
            })
        }
    }
}

struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesList(
            logout: nop,
            ids: Array(1...3).map(Movie.Id.init),
            loadNextPage: nop,
            row: { id in MovieRow(
                title: "Harry Potter and the Philosopher\'s Stone",
                description: "Harry Potter has lived under the stairs at his aunt and uncle\'s house his whole life. But on his 11th birthday, he learns he\'s a powerful wizard -- with a place waiting for him at the Hogwarts School of Witchcraft and Wizardry. As he learns to harness his newfound powers with the help of the school\'s kindly headmaster, Harry uncovers the truth about his parents\' deaths -- and about the villain who\'s to blame.",
                poster: nil,
                isFavorite: true
            )},
            searchbar: { Searchbar_Previews.previews },
            movieDetails: { _ in MovieDetails_Previews.previews }
        )
    }
}

struct MoviesListConnector: Connector {
    
    func map(state: AppState, store: EnvironmentStore) -> some View {
        let moviesList = {
            MoviesList(
                logout: store.bind(.logout),
                ids: state.moviesList.ids,
                loadNextPage: state.moviesList.canRequestNextPage
                    ? store.bind(.requestNextMoviesPage)
                    : nil,
                row: { MovieRowConnector(id: $0) },
                searchbar: { SearchbarConnector() },
                movieDetails: { id in MovieDetailsConnector(id: id) }
            )
        }
        
        let searchResults = {
            MoviesList(
                logout: store.bind(.logout),
                ids: state.searchResults.results,
                loadNextPage: state.searchResults.canRequestNextPage
                    ? store.bind(.requestNextSearchPage)
                    : nil,
                row: { MovieRowConnector(id: $0) },
                searchbar: { SearchbarConnector() },
                movieDetails: { id in MovieDetailsConnector(id: id) }
            )
        }
        
        if state.searchResults.query.isEmpty {
            return moviesList()
        } else {
            return searchResults()
        }
    }
}
