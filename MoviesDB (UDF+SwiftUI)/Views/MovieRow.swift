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
