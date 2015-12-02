//
//  Movie.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-26.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

class Movie:Media {
    
    private var ageRestriction: Int?
    private var mainActors: String?
    private var director: String?
    
    override init(title: String, released: Int, runtime: Runtime) {
        super.init(title: title, released: released, runtime: runtime)
    }
    
    func setAgeRestriction(age: Int?) {
        ageRestriction = age
    }
    
    func setMainActors(mainActors: String?) {
        self.mainActors = mainActors
    }
    
    func setDirector(director: String?) {
        self.director = director
    }
    
    func getAgeRestriction() -> Int? {
        return ageRestriction
    }
    
    func getMainActors() -> String? {
        return mainActors
    }
    
    func getDirector() -> String? {
        return director
    }
    
    func toDictionary() -> [String:String] {
        var movieDict = [String:String]()
        
        movieDict["title"] = super.getTitle()
        movieDict["release"] = String(super.getReleaseYear())
        movieDict["runtime"] = super.getRuntime().toString()
        
        if let genre = super.getGenre() {
            movieDict["genre"] = genre
        }
        
        if let description = super.getDescription() {
            movieDict["description"] = description
        }
        
        if let format = super.getFormat() {
            movieDict["format"] = format.rawValue
        }
        
        movieDict["owningType"] = super.getOwningType()!.rawValue
        
        if let ownerLocation = super.getOwnerLocation() {
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
