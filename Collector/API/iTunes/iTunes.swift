import Foundation

public struct Itunes: API {
    let request = Request()
    
    /// Creates a instance of the Itunes API
    ///  - parameters:
    ///     - api: resource to use when dispatching a request
    ///     - completion: callback function when the request has been handled
    public init(_ api: APIResource, completion: (Result<Response>) -> Void) {
        //api.resource.urlDomain("itunes.apple.com", scheme: URL.Scheme.HTTPS)
        api.resource.urlDomain("dino.opij.ac")
        
        print(api.resource.url)
        
        request.dispatch(Request.Source.URL(api.resource.url), completion: completion)
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
    private static func parseOneAlbum(json: JSON) -> iTunesAlbumItem? {
        if json["collectionType"].string! == "Album" {
            return iTunesAlbumItem(
                id:     String(json["collectionId"].int!),
                name:   json["collectionName"].string!,
                artist: json["artistName"].string!,
                image:  json["artworkUrl100"].string!,
                release:json["releaseDate"].string!,
                genre:  json["primaryGenreName"].string!,
                tracks: nil)
        }
        
        return nil
    }
    
    /// Parses a single track in a album
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    private static func parseOneTrack(json: JSON) -> iTunesAlbumTrackItem? {
        if json["wrapperType"].string! == "track" {
            let durationOptional = json["trackTimeMillis"].int
            if let duration = durationOptional {
                return iTunesAlbumTrackItem(
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
    public static func parseAlbum(json: JSON) -> iTunesAlbumItem? {
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

                album?.tracks = [iTunesAlbumTrackItem]()

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
    public static func parseSearch(json: JSON) -> [iTunesAlbumItem]? {
        if didParseSuccessfully(json) {
            let results = json["results"].array!
            
            if results.count > 0 {
                var items = [iTunesAlbumItem]()
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