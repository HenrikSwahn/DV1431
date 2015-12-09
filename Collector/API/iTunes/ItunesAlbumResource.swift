import Foundation

public struct ItunesAlbumResource: APIResource {
    public var resource: URL = URL(pathed: "/lookup")
    
    public init(id: String) {
        resource.urlField(named: "entity", "song")
        resource.urlField(named: "id", id)
        
        //resource.urlPath(pathed: "/itunes_album.json")
    }
}