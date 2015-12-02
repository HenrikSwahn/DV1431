//
//  Store.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-30.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Storage {
    
    private var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func storeMovie(movie: Movie) -> Bool {
        
        let movieStoreDesc = NSEntityDescription.entityForName("Movie", inManagedObjectContext: managedObjectContext)
        let storeMovie = MovieStore(entity: movieStoreDesc!, insertIntoManagedObjectContext: managedObjectContext)
        
        storeMovie.title = movie.getTitle()
        storeMovie.runtime = movie.getRuntime().getTotalInSeconds()
        storeMovie.releaseYear = movie.getReleaseYear()
        
        if let owningType = movie.getOwningType() {
            storeMovie.owningType = owningType.rawValue
        }
        
        if let ownerLocation = movie.getOwnerLocation() {
            storeMovie.ownerLocation = ownerLocation
        }
        
        if let genre = movie.getGenre() {
            storeMovie.genre = genre
        }
        
        if let description = movie.getDescription() {
            storeMovie.desc = description
        }
        
        if let format = movie.getFormat() {
            storeMovie.format = format.rawValue
        }
        
        if let coverArt = movie.getCoverArt() {
            let imageData = UIImageJPEGRepresentation(coverArt, 1)
            storeMovie.coverArt = imageData
        }
        
        if let director = movie.getDirector() {
            storeMovie.director = director
        }
        
        if let ageRestriction = movie.getAgeRestriction() {
            storeMovie.ageRestriction = ageRestriction
        }
        
        if let mainActors = movie.getMainActors() {
            storeMovie.mainActors = mainActors
        }
        
        do {
            try managedObjectContext.save()
        }
        catch {
            return false
        }
        return true
    }
    
    func getMovies() -> [Movie]? {
        var storedMovies = [MovieStore]()
        
        let request = NSFetchRequest(entityName: "Movie")
        
        do {
            try storedMovies = managedObjectContext.executeFetchRequest(request) as! [MovieStore]
            var movies = [Movie]()
            for mStore in storedMovies {
                let movie = Movie(title: mStore.title!, released: Int(mStore.releaseYear!), runtime: Runtime.getRuntimeBasedOnSeconds(Int(mStore.runtime!)))
                
                if let genre = mStore.genre {
                    movie.setGenre(genre)
                }
                
                if let desc = mStore.desc {
                    movie.setDescription(desc)
                }
                
                if let ownerLocation = mStore.ownerLocation {
                    movie.setOwnerLocation(ownerLocation)
                }
                
                if let coverArt = UIImage(data: mStore.coverArt!) {
                    movie.setCoverArt(coverArt)
                }
                
                if let format = mStore.format {
                    movie.setFormat(format)
                }
                
                if let owningType = mStore.owningType {
                    movie.setOwningType(owningType)
                }
                
                if let ageRestriction = mStore.ageRestriction {
                    movie.setAgeRestriction(Int(ageRestriction))
                }
                
                if let mainActors = mStore.mainActors {
                    movie.setMainActors(mainActors)
                }
                
                if let director = mStore.director {
                    movie.setDirector(director)
                }
                
                movies.append(movie)
            }
            return movies
        }    
        catch {
            fatalError("Could not execute query")
        }
    }
    
    // MARK: - Dev
    func emptyDatabase() {
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.executeRequest(deleteRequest)
        }catch {
            fatalError("Error deleting batabase")
        }
    }
}