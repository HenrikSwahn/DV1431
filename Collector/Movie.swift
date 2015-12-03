//
//  Movie.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-26.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

class Movie:Media {
    
    var ageRestriction: Int?
    var mainActors: String?
    var director: String?
    
    override init(title: String, released: Int, runtime: Runtime) {
        super.init(title: title, released: released, runtime: runtime)
    }
    
    func toDictionary() -> [String:String] {
        var movieDict = [String:String]()
        
        movieDict["title"] = super.title
        movieDict["release"] = String(super.releaseYear)
        movieDict["runtime"] = super.runtime.toString()
        
        if let genre = super.genre {
            movieDict["genre"] = genre
        }
        
        if let description = super.desc {
            movieDict["description"] = description
        }
        
        if let format = super.format {
            movieDict["format"] = format.rawValue
        }
        
        movieDict["owningType"] = super.owningType!.rawValue
        
        if let ownerLocation = super.ownerLocation {
            movieDict["ownerLocation"] = ownerLocation
        }
        
        if let ageRes = self.ageRestriction {
            movieDict["ageRestriction"] = String(ageRes)
        }
        
        if let actors = self.mainActors {
            movieDict["mainActors"] = String(actors)
        }
        
        if let dir = self.director {
            movieDict["director"] = dir
        }
        
        return movieDict
    }
}
