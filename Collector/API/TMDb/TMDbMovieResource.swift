import Foundation

public struct TMDbMovieResource: APIResource {
    public var resource = URL(pathed: "/3/movie/id")
    
    public init(id: Int) {
        //resource.urlPath(args: id)
        resource.urlField(named: "append_to_response", "credits")
        resource.urlPath(pathed: "/tmdb_movie.json")
    }
}