import Foundation

public class LastFM: API {
    private let request = Request()
    
    /// Creates a instance of the LastFM API
    ///  - parameters:
    ///     - api: resource to use when dispatching a request
    ///     - completion: callback function when the request has been handled
    public required init(_ api: APIResource, completion: (Result<Response>) -> Void) {
        super.init(api, completion: completion)
        //api.resource.urlDomain("ws.audioscrobbler.com")
        api.resource.urlField(named: "api_key", "6aec100ca9d5d3e4e30477dd0f1fc103")
        api.resource.urlField(named: "format", "json")
        
        api.resource.urlDomain("app.opij.ac")
        
        request.dispatch(Request.Source.URL(api.resource.url), completion: completion)
    }
    
    /// Helper method for retrieving the best size class
    ///  - parameters:
    ///     - size: a string representation of the size
    ///  - returns: a function which determines if the size class is retrieved
    private static func size(size: String) -> (JSON) throws -> Bool {
        return { item throws in
            return item["size"].string! == size && item["#text"].string!.characters.count > 0
        }
    }
    
    /// The LastFM API returns several versions of a image in different quality formats.
    ///
    /// The available formats are "small", "medium", "large" and "extralarge". This method
    /// attempts to retrieve the best image, starting with "large"
    ///
    /// - parameters:
    ///     - json: an array containing the different image sizes
    public static func parseImage(json: Array<JSON>?) -> String? {
        if let images = json {
            var candidate: [JSON]
            
            do {
                candidate = try images.filter(size("large"))
                if candidate.count > 0 { return candidate[0]["#text"].string }
                
                candidate = try images.filter(size("medium"))
                if candidate.count > 0 { return candidate[0]["#text"].string }
                
                candidate = try images.filter(size("small"))
                if candidate.count > 0 { return candidate[0]["#text"].string }
            } catch(_) {}
        }
        
        return nil
    }
    
    /// Parses a search
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseSearch(json: JSON) -> [LastFMSearchItem]? {
        if let results = json["results"]["albummatches"]["album"].array {
            var items = [LastFMSearchItem]()
            
            results.forEach { item in
                // If the item has no ID, ignore it.
                if let id = item["mbid"].string {
                    if id.characters.count > 0 {
                        items.append(LastFMSearchItem(id:     item["mbid"].string ?? "Unavailable",
                            name:   item["name"].string ?? "Unavailable",
                            artist: item["artist"].string ?? "Unavailable",
                            image:  self.parseImage(item["image"].array)))
                    }
                }
            }
            
            return items
        }
        
        return nil
    }
    
    /// Parses a album
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseAlbum(json: JSON) -> LastFMAlbumItem? {
        let album = json["album"]
        return LastFMAlbumItem(
            id:     album["mbid"].string ?? "Unavailable",
            name:   album["name"].string! ?? "Unavailable",
            artist: album["artist"].string! ?? "Unavailable",
            image:  self.parseImage(album["image"].array),
            tracks: self.parseAlbumTracks(json))
    }
    
    /// Parses album tracks
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    private static func parseAlbumTracks(json: JSON) -> [LastFMAlbumTrackItem]? {
        if let tracks = json["album"]["tracks"]["track"].array {
            return tracks.map(self.parseAlbumTrack)
        }
        
        return nil
    }
    
    /// Parses a single album track
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    private static func parseAlbumTrack(json: JSON) -> LastFMAlbumTrackItem {
        return LastFMAlbumTrackItem(
            title:  json["name"].string!,
            artist: json["artist"]["name"].string!,
            duration: json["duration"].string!
        )
    }
}