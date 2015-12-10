import Foundation

public class Itunes: API {
    var request: Request?
    var resource: APIResource?
    
    /// Creates a instance of the Itunes API
    ///  - parameters:
    ///     - api: resource to use when dispatching a request
    public required init(resource: APIResource) {
        self.request = Request()
        self.resource = resource
        
        self.resource!.resource.urlDomain("itunes.apple.com", scheme: URL.Scheme.HTTPS)
    }
    
    public func request(completion: (Result<Response>) -> Void) {
        if let url = self.resource?.resource.url {
            self.request?.dispatch(Request.Source.URL(url), completion: completion)
        } else {
            print("No url has been set.")
        }
    }
    
    /// Helper function to perform a check for the given data
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    private static func didParseSuccessfully(json: JSON) -> Bool {
        if let result = json["resultCount"].int {
            if result != 0 {
                return true
            }
        }
        
        return false
    }
    
    /// Parses a single album
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    private static func parseOneAlbum(json: JSON) -> ItunesAlbumItem? {
        if json["collectionType"].string! == "Album" {
            return ItunesAlbumItem(
                id:         String(json["collectionId"].int!),
                name:       json["collectionName"].string!,
                artist:     json["artistName"].string!,
                image:      json["artworkUrl100"].string!,
                release:    dateToYear(json["releaseDate"].string),
                trackCount: String(json["trackCount"].int!),
                genre:      json["primaryGenreName"].string!,
                tracks:     nil)
        }
        
        return nil
    }
    
    /// Parses a single track in a album
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    private static func parseOneTrack(json: JSON) -> ItunesAlbumTrackItem? {
        if json["wrapperType"].string! == "track" {
            let durationOptional = json["trackTimeMillis"].int
            if let duration = durationOptional {
                return ItunesAlbumTrackItem(
                    title:      json["trackName"].string!,
                    artist:     json["artistName"].string!,
                    duration:   duration > 0 ? "\(Int(duration / 1000))" : "0"
                )
            }
        }
        
        return nil
    }
    
    /// Parses a complete album
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseAlbum(json: JSON) -> ItunesAlbumItem? {
        if didParseSuccessfully(json) {
            var results = json["results"].array!
            
            switch results.count {
            case 0:
                return nil
            case 1:
                return parseOneAlbum(results[0])
            default:
                var album = parseOneAlbum(results[0])
                var tracks = results
                    tracks.removeFirst()

                album?.tracks = [ItunesAlbumTrackItem]()

                tracks.forEach() { track in
                    if let validTrack = parseOneTrack(track) {
                        album?.tracks?.append(validTrack)
                    }
                }
                
                return album
            }
        }
        
        return nil
    }
    
    /// Parses a search
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseSearch(json: JSON) -> [ItunesAlbumItem]? {
        if didParseSuccessfully(json) {
            let results = json["results"].array!
            
            if results.count > 0 {
                var items = [ItunesAlbumItem]()
                results.forEach() { album in
                    if let validAlbum = parseOneAlbum(album) {
                        items.append(validAlbum)
                    }
                }
                
                return items
            }
        }
        
        return nil
    }
}