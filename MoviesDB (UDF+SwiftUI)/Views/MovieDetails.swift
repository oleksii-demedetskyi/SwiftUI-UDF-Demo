import SwiftUI

struct MovieDetails: View {
    let title: String
    let image: UIImage?
    let overview: String
    let isFavorite: Binding<Bool>
    
    var body: some View {
        VStack {
            HStack {
                Text(title).font(.largeTitle)
                Button(action: toggleFavorite) {
                    FavoriteIndicator(isFavorite: isFavorite.wrappedValue)
                }
            }
            image.map { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            Text(overview)
            Spacer()
        }
    }
    
    func toggleFavorite() {
        isFavorite.wrappedValue.toggle()
    }
}

struct MovieDetails_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetails(
            title: "Kill bill",
            image: nil,
            overview: "A very long text",
            isFavorite: .constant(true)
        )
    }
}

struct MovieDetailsConnector: Connector {
    @Environment(\.imageCache) var cache
    let id: Movie.Id
    
    func map(state: AppState, store: EnvironmentStore) -> some View {
        guard let movie = state.allMovies.byId[id] else {
            preconditionFailure()
        }
        
        return MovieDetails(
            title: movie.title,
            image: cache.image(for: id),
            overview: movie.description,
            isFavorite: Binding(
                get: { state.favoriteMovies.favorites.contains(self.id) },
                set: { isFavorite in
                    store.dispatch(isFavorite
                        ? .addToFavorite(self.id)
                        : .removeFromFavorites(self.id)
                    )
            })
        )
    }
}
