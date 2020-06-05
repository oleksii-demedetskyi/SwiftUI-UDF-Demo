import SwiftUI

struct MovieRow: View {
    let title: String
    let description: String
    let poster: UIImage?
    let isFavorite: Binding<Bool>
    
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

struct MovieRow_Previews: PreviewProvider {
    static let initial = MovieRow(
        title: "Harry Potter and the Philosopher\'s Stone",
        description: "Harry Potter has lived under the stairs at his aunt and uncle\'s house his whole life. But on his 11th birthday, he learns he\'s a powerful wizard -- with a place waiting for him at the Hogwarts School of Witchcraft and Wizardry. As he learns to harness his newfound powers with the help of the school\'s kindly headmaster, Harry uncovers the truth about his parents\' deaths -- and about the villain who\'s to blame.",
        poster: nil,
        isFavorite: .constant(false)
    )
    static var previews: some View {
        List {
            initial
            initial
            initial
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
            isFavorite: .constant(false)
        )
    }
}
