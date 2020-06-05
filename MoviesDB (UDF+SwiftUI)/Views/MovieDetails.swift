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
            overview: "A very long text"
        )
    }
}
