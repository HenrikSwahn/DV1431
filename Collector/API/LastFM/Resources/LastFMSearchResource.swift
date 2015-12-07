import Foundation

public struct LastFMSearchResource: APIResource {
    public var resource: URL = URL(pathed: "/2.0")
    
    public init(forTerm term: String) {
        resource.urlField(named: "method", "album.search")
        //resource.urlField(named: "album", term)
        
        resource.urlPath(pathed: "/lastfm_search.json")
    }
}