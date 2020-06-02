import SwiftUI
import Combine
import Core

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = ImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

class ImageCache {
    private var posters = [Movie.Id: UIImage]()
    
    func store(poster image: UIImage, for id: Movie.Id) {
        posters[id] = image
    }
    
    func hasPoster(for id: Movie.Id) -> Bool {
        return posters.keys.contains(id)
    }
    
    func image(for id: Movie.Id) -> UIImage? {
        posters[id]
    }
}
