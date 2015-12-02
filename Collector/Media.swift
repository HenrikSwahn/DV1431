
import UIKit

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
    
    private var title: String
    private var releaseYear: Int
    private var runtime: Runtime
    private var genre: String?
    private var desc: String?
    private var format: Format?
    private var owningType: OwningType?
    private var ownerLocation: String?
    private var coverArt: UIImage?
    
    init(title: String, released: Int, runtime: Runtime) {
        self.title = title
        self.releaseYear = released
        self.runtime = runtime
    }
    
    // MARK: - Getters
    func getTitle() -> String {
        return title
    }
    
    func getReleaseYear() -> Int {
        return releaseYear
    }
    
    func getRuntime() -> Runtime {
        return runtime
    }
    
    func getGenre() -> String? {
        return genre
    }
    
    func getDescription() -> String? {
        return desc
    }
    
    func getFormat() -> Format? {
        return format
    }
    
    func getOwningType() -> OwningType? {
        return owningType
    }
    
    func getOwnerLocation() -> String? {
        return ownerLocation
    }
    
    func getCoverArt() -> UIImage? {
        return coverArt
    }
    
    // MARK: - Setters
    func setGenre(genre: String?) {
        self.genre = genre
    }
    
    func setDescription(desc: String?) {
        self.desc = desc
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
    
    func setOwnerLocation(location: String?) {
        self.ownerLocation = location
    }
    
    func setCoverArt(image: UIImage?) {
        self.coverArt = image
    }
}
