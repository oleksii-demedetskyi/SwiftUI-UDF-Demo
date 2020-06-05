import SwiftUI

struct MovieDetails: View {
    let title: String
    let image: UIImage?
    let overview: String
    
    var body: some View {
        VStack {
            Text(title).font(.largeTitle)
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
            overview: "A lot of text"
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
            overview: movie.description
        )
    }
}
