
import UIKit

// Todo: Rating variable
class Media {
    
    enum OwningType: String {
        case Physical = "Physical"
        case Digital = "Digital"
        case NotOwned = "Not owned"
    }
    
    enum Format:String {
        case DVD = "DVD"
        case BLURAY = "Blu-Ray"
        case VHS = "VHS"
        case MP4 = "MP4"
        case CD = "CD"
        case MP3 = "MP3"
        case FLAC = "Flac"
    }
    
    var title: String
    var releaseYear: Int
    var runtime: Runtime
    var genre: String?
    var desc: String?
    var format: Format?
    var owningType: OwningType?
    var ownerLocation: String?
    var coverArt: UIImage?
    
    init(title: String, released: Int, runtime: Runtime) {
        self.title = title
        self.releaseYear = released
        self.runtime = runtime
    }
    
    func setFormat(format: String?) {
        
        if let f = format {
            switch(f) {
            case "DVD":
                self.format = .DVD
                break
            case "Blu-Ray":
                self.format = .BLURAY
                break
            case "VHS":
                self.format = .VHS
                break
            case "MP4":
                self.format = .MP4
                break
            case "CD":
                self.format = .CD
                break
            case "MP3":
                self.format = .MP3
                break
            case "FLAC":
                self.format = .FLAC
                break
            default:
                self.format = .DVD
                break
            }
        }
    }
    
    func setOwningType(type: String?) {
        
        if let t = type {
            switch(t) {
            case "Physical":
                owningType = .Physical
                break
            case "Digital":
                owningType = .Digital
                break
            default:
                owningType = .NotOwned
                break
            }
        }
    }
}
