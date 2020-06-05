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
                Spacer()
                Button(action: nop) {
                    if (isFavorite.wrappedValue) {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
            }
            .padding([.leading, .trailing], 24)
            image.map { image in
                Image(uiImage: image)
                .resizable()
                .scaledToFit()
            }
            Text(overview)
            Spacer()
        }
    }
}

struct MovieDetails_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetails(
            title: "Kill bill",
            image: nil,
            overview: "A lot of text",
            isFavorite: State(initialValue: true).projectedValue
        )
    }
}

struct MovieDetailsConnector: Connector {
    let id: Movie.Id
    
    func map(state: AppState, store: EnvironmentStore) -> MovieDetails {
        guard let movie = state.allMovies.byId[id] else {
            preconditionFailure()
        }
        
        return MovieDetails(
            title: movie.title,
            image: nil,
            overview: movie.description,
            isFavorite: State(initialValue: true).projectedValue
        )
    }
}
