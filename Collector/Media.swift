
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
    private var owningType: OwningType
    private var ownerLocation: String?
    private var coverArt: UIImage?
    
    init(title: String, released: Int, runtime: Runtime) {
        self.title = title
        self.releaseYear = released
        self.runtime = runtime
        owningType = .NotOwned
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
    
    func getOwningType() -> OwningType {
        return owningType
    }
    
    func getOwnerLocation() -> String? {
        return ownerLocation
    }
    
    func getCoverArt() -> UIImage? {
        return coverArt
    }
    
    // MARK: - Setters
    func setTitle(title: String) {
        self.title = title
    }
    
    func setReleaseYear(year: Int) {
        self.releaseYear = year
    }
    
    func setRuntime(runtime: Runtime) {
        self.runtime = runtime
    }
    
    func setGenre(genre: String) {
        self.genre = genre
    }
    
    func setDescription(desc: String) {
        self.desc = desc
    }
    
    func setFormat(format: Format) {
        self.format = format
    }
    
    func setOwningType(type: OwningType) {
        
        self.owningType = type
    }
    
    func setOwnerLocation(location: String) {
        self.ownerLocation = location
    }
    
    func setCoverArt(image: UIImage) {
        self.coverArt = image
    }
}
