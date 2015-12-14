//
//  TMDbConfigurationResource.swift
//  Collector
//
//  Created by Dino Opijac on 05/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

public class TMDb: API {
    var request: Request?
    var resource: APIResource?
    
    public struct Configuration {
        /// Update interval for configuration
        public static let UpdateInterval: Double = 4 * 24 * 60 * 60
        
        // Determine if the URLs should use HTTPs requests
        public static let UseHTTPS = true
        
        /// Key of the configuration in NSUserDefaults
        public static let Key = "TMDbConfiguration"
    }
    
    /// Creates a instance of the TMDb API
    ///  - parameters:
    ///     - api: resource to use when dispatching a request
    public required init(resource: APIResource) {
        self.request = Request()
        self.resource = resource
        
        self.resource?.resource.urlDomain("api.themoviedb.org")
        self.resource?.resource.urlField(named: "api_key", "3bde72620dd396beec310a3e1d30ce6a")
    }
    
    public func request(completion: (Result<Response>) -> Void) {
        if let url = self.resource?.resource.url {
            self.request?.dispatch(Request.Source.URL(url), completion: completion)
        } else {
            print("No url has been set.")
        }
    }
    
    /// Parses a single movie result
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseMovie(json: JSON) -> TMDbMovieItem? {
        var cast = [String]()
        var genres = [String]()
        var director = "None available"
        var videos: [(title: String, URL: String)]? = nil
        
        if let actors = json["credits"]["cast"].array {
            let allActors = actors.map({ $0["name"].string! })
            
            if allActors.count >= 3 {
                cast = Array(allActors.prefixUpTo(3))
            } else {
                cast = allActors
            }
        }
        
        if let directors = json["credits"]["crew"].array {
            let filteredDirectors = directors.filter({ (item) -> Bool in
                if let d = item["job"].string {
                    return d == "Director"
                }
                return false
            })
            
            let directors = filteredDirectors.map({ $0["name"].string! })
            director = directors.joinWithSeparator(" ")
        }
        
        if let genrez = json["genres"].array {
            genrez.forEach { item in
                genres.append(item["name"].string!)
            }
        }
        
        if let videoResults = json["videos"]["results"].array {
            videos = [(title: String, URL: String)]()
            videoResults.forEach() { item in
                let title = String(format: "%@ (%dp)", item["name"].string!, item["size"].int!)
                videos?.append((title: title, URL: item["key"].string!))
            }
        }
        
        return TMDbMovieItem(
            id:                 String(json["id"].int ?? 0),
            image:              appendImageURL(json["poster_path"].string),
            release:            dateToYear(json["release_date"].string),
            language:           json["original_language"].string ?? "en",
            title:              json["original_title"].string ?? "Unavailable",
            synopsis:           json["overview"].string ?? "Unavailable",
            runtime:            json["runtime"].int ?? 0,
            cast:               cast,
            director:           director,
            genres:             genres,
            videos:             videos
        )
    }
    
    /// Parses a search
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseSearch(json: JSON) -> [TMDbSearchItem]? {
        if let results = json["results"].array {
            var items = [TMDbSearchItem]()
            results.forEach { item in
                items.append(TMDbSearchItem(
                    id:         String(item["id"].int ?? 0),
                    image:      appendImageURL(item["poster_path"].string),
                    release:    dateToYear(item["release_date"].string),
                    title:      item["title"].string ?? "Unavailable",
                    synopsis:   item["overview"].string ?? "Unavailable")
                )
            }
            
            return items
        }

        return nil
    }
    
    /// Parses a configuration
    ///  - parameters:
    ///     - json: JSON object containing the data to be adapted
    public static func parseConfiguration(json: JSON) -> TMDbConfigurationItem? {
        if let configuration = json.object {
            if let images = configuration["images"] {               
                return TMDbConfigurationItem(
                    baseURL:        images["base_url"].string!,
                    baseURLSecured: images["secure_base_url"].string!
                )
            }
        }
        return nil
    }
    
    /// Saves the configuration to NSUserDefaults
    public static func saveConfigurationToUserDefaults() {
        let tmdb = TMDb(resource: TMDbConfigurationResource())
        tmdb.request { result in
            switch result {
                case .Error(_): break
                case .Success(let res):
                    if let config = TMDb.parseConfiguration(JSON(res.data)) {
                        let defaults = NSUserDefaults()
                        defaults.setObject(config.propertyList, forKey: TMDb.Configuration.Key)
                        defaults.synchronize()
                    }
                }
            }
    }
    
    /// Appends a URL to a image
    /// - parameters:
    ///     - image: the resource image
    private static func appendImageURL(resource: String?) -> String {
        if let item = TMDbConfigurationItem.fromUserDefaults() {
            if let image = resource {
                let size = item.poster["xs"]!
                
                if (TMDb.Configuration.UseHTTPS) {
                    return item.baseURLSecured + size + image
                }
                
                return item.baseURL + size + image
            }
        }
        
        return "/"
    }
}