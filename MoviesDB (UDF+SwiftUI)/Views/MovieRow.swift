import SwiftUI

struct FavoriteIndicator: View {
    let isFavorite: Bool
    
    var body: some View {
        Image(systemName: isFavorite
            ? "star.fill"
            : "star"
        )
    }
}

struct MovieRow: View {
    let title: String
    let description: String
    let poster: UIImage?
    let isFavorite: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Group {
                if (poster != nil) {
                    Image(uiImage: poster!)
                } else {
                    Color.gray
                }
            }
            .frame(width: 92, height: 138)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    Spacer()
                    FavoriteIndicator(isFavorite: isFavorite)
                }
                Spacer()
                Text(description)
                    .lineLimit(4)
                    .truncationMode(.tail)
            }
        }
    }
}

struct MovieRowConnector: Connector {
    @Environment(\.imageCache) var imageCache
    let id: Movie.Id
    
    func map(state: AppState, store: EnvironmentStore) -> some View {
        let movie = state.allMovies.byId[id]!
        return MovieRow(
            title: movie.title,
            description: movie.description,
            poster: imageCache.image(for: id),
            isFavorite: state.favoriteMovies.favorites.contains(id)
        )
    }
}
