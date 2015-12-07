import Foundation

public struct LastFMAlbumResource: APIResource {
    public var resource: URL = URL(pathed: "/2.0")
    
    public init(id: String) {
        resource.urlField(named: "method", "album.getInfo")
        resource.urlField(named: "mbid", id)
        
        resource.urlPath(pathed: "/lastfm_album.json")
    }
}