import Foundation

public struct TMDbSearchResource: APIResource {
    public var resource = URL(pathed: "/3/search/movie")
    
    public init(forTerm term: String) {
        resource.urlField(named: "query", term)
        resource.urlPath(pathed: "/tmdb_search.json")
    }
}