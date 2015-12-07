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

enum SearchSet: String {
    case Movie = "Movie"
    case Music = "Music"
    case Union = "Union"
}

enum DBTable {
    case Title
    case ReleaseYear
    case Genre
}

struct DBSearch {
    let table: DBTable?
    let searchString: String?
    let batchSize: Int?
    let set: SearchSet
    
    init(table: DBTable?, searchString: String?, batchSize: Int?, set: SearchSet) {
        self.table = table
        self.searchString = searchString
        self.batchSize = batchSize
        self.set = set
    }
}

class Storage {
    
    private var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func storeMovie(movie: Movie) -> Bool {
        
        let movieStoreDesc = NSEntityDescription.entityForName("Movie", inManagedObjectContext: managedObjectContext)
        let storeMovie = MovieStore(entity: movieStoreDesc!, insertIntoManagedObjectContext: managedObjectContext)
        
        storeMovie.title = movie.title
        storeMovie.runtime = movie.runtime.getTotalInSeconds()
        storeMovie.releaseYear = movie.releaseYear
        
        if let owningType = movie.owningType {
            storeMovie.owningType = owningType.rawValue
        }
        
        if let ownerLocation = movie.ownerLocation {
            storeMovie.ownerLocation = ownerLocation
        }
        
        if let genre = movie.genre {
            storeMovie.genre = genre
        }
        
        if let description = movie.desc {
            storeMovie.desc = description
        }
        
        if let format = movie.format {
            storeMovie.format = format.rawValue
        }
        
        if let coverArt = movie.coverArt {
            let imageData = UIImageJPEGRepresentation(coverArt, 1)
            storeMovie.coverArt = imageData
        }
        
        if let director = movie.director {
            storeMovie.director = director
        }
        
        if let ageRestriction = movie.ageRestriction {
            storeMovie.ageRestriction = ageRestriction
        }
        
        if let mainActors = movie.mainActors {
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
    
    func convertToMovie(data: [MovieStore]) -> [Movie] {
        var movies = [Movie]()
        for mStore in data {
            let movie = Movie(title: mStore.title!, released: Int(mStore.releaseYear!), runtime: Runtime.getRuntimeBasedOnSeconds(Int(mStore.runtime!)))
            
            if let genre = mStore.genre {
                movie.genre = genre
            }
            
            if let desc = mStore.desc {
                movie.desc = desc
            }
            
            if let ownerLocation = mStore.ownerLocation {
                movie.ownerLocation = ownerLocation
            }
            
            if let coverArt = UIImage(data: mStore.coverArt!) {
                movie.coverArt = coverArt
            }
            
            if let format = mStore.format {
                movie.setFormat(format)
            }
            
            if let owningType = mStore.owningType {
                movie.setOwningType(owningType)
            }
            
            if let ageRestriction = mStore.ageRestriction {
                movie.ageRestriction = Int(ageRestriction)
            }
            
            if let mainActors = mStore.mainActors {
                movie.mainActors = mainActors
            }
            
            if let director = mStore.director {
                movie.director = director
            }
            
            movies.append(movie)
        }
        return movies
    }
    
    // MARK: - Search
    func searchDatabase(search: DBSearch) -> [Media]? {
        
        switch search.set {
        case .Movie:
            return searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: search.set)
        case .Music:
            return searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: search.set)
        case .Union:
            let arrOne = searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: .Movie)
            let arrTwo = searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: .Music)
            
            if (arrOne != nil) && (arrTwo != nil) {
                return arrOne! + arrTwo!
            }
            else if (arrOne != nil) && (arrTwo == nil) {
                return arrOne!
            }
            else if (arrOne == nil) && (arrTwo != nil) {
                return arrTwo!
            }
            else {
                return nil
            }
        }
    }
    
    private func searchData(table: DBTable?, search: String?, batchSize: Int?, set: SearchSet) -> [Media]? {
        
        let request = NSFetchRequest(entityName: set.rawValue)
        
        if (table != nil) && (search != nil) {
            
            switch table! {
            case .Title:
                request.predicate = NSPredicate(format: "title==%@", search!)
                break
            case .ReleaseYear:
                request.predicate = NSPredicate(format: "releaseYear==%@", Int(search!)!)
                break
            case .Genre:
                request.predicate = NSPredicate(format: "genre==%@", search!)
                break
            }

        }
        
        if (batchSize != nil) {
            request.fetchBatchSize = batchSize!
        }
        
        if set == .Movie {
            var results = [MovieStore]()
            do {
                try results = managedObjectContext.executeFetchRequest(request) as! [MovieStore]
                return convertToMovie(results)
            }
            catch {
                fatalError("Error searching for data")
            }
        }
        else if set == .Music {
            //var results = [MusicStore]()
            //do {
              //  try results = managedObjectContext.executeFetchRequest(request) as! [MovieStore]
            //}
            //catch {
              //  fatalError("Error searching for data")
            //}

        }
        
        
    
        return nil
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