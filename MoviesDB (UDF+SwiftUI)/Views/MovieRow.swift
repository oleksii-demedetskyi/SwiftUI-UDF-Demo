import SwiftUI

struct MovieRow: View {
    let title: String
    let description: String
    let poster: UIImage?
    
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
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                    .truncationMode(.tail)
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
            poster: imageCache.image(for: id))
    }
}
