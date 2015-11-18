
import UIKit

class Media {
    var name: String
    var release: Int
    var length: String
    var image: UIImage
    
    init(named name: String, released release: Int, length: String, image: UIImage?) {
        self.name = name
        self.release = release
        self.length = length
        
        if let img = image {
            self.image = img
        } else {
            self.image = UIImage(named: "placeholder-movie")!
        }
    }
}
