import Foundation

public struct TMDb: API {
    private let request = Request()
    
    /// Creates a instance of the TMDb API
    ///  - parameters:
    ///     - api: resource to use when dispatching a request
    ///     - completion: callback function when the request has been handled
    public init(_ api: APIResource, completion: (Result<Response>) -> Void) {
        //api.resource.urlDomain("api.themoviedb.org")
        api.resource.urlField(named: "api_key", "3bde72620dd396beec310a3e1d30ce6a")
        api.resource.urlDomain("dino.opij.ac")
        
        print(api.resource.url)
        
        request.dispatch(Request.Source.URL(api.resource.url), completion: completion)
    }
    
    /// Parses a single movie result
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseMovie(json: JSON) -> TMDbMovieItem? {
        var cast = [String]()
        var genres = [String]()
        
        if let actors = json["credits"]["cast"].array {
            cast = actors.map({ $0["name"].string! })
        }
        
        if let genrez = json["genres"].array {
            genrez.forEach { item in
                genres.append(item["name"].string!)
            }
        }
        
        return TMDbMovieItem(
            id: json["id"].int ?? 0,
            image: json["poster_path"].string ?? "Unavailable",
            release_date: json["release_date"].string ?? "Unavailable",
            language: json["original_language"].string ?? "en",
            title: json["original_title"].string ?? "Unavailable",
            synopsis: json["overview"].string ?? "Unavailable",
            cast: cast,
            genres: genres
        )
    }
    
    /// Parses a search
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseSearch(json: JSON) -> [TMDbSearchItem]? {
        if let results = json["results"].array {
            var items = [TMDbSearchItem]()
            results.forEach { item in
                print(item)
                items.append(TMDbSearchItem(
                    id: item["id"].int ?? 0, image: item["poster_path"].string ?? "/",
                    release_date: item["release_date"].string ?? "1970-01-01",
                    title: item["title"].string ?? "Unavailable")
                )
            }
            
            return items
        }

        return nil
    }
}