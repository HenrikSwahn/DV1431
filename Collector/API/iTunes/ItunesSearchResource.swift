import Foundation

public struct ItunesSearchResource: APIResource {
    public var resource: URL = URL(pathed: "/search")
    
    public init(forTerm term: String) {
        resource.urlField(named: "entity", "album")
        resource.urlField(named: "term", term)
        //resource.urlField(named: "album", term)
        
        resource.urlPath(pathed: "/itunes_search.json")
    }
}