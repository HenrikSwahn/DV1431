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
    case Track = "Track"
    case WishListItem = "WishListItem"
    case Union = "Union"
}

enum DBTable {
    case MovieId
    case MusicId
    case Title
    case ReleaseYear
    case Genre
    
    //Whist list specific
    case Id
    case Aid
    case Type
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
        let results = searchData(.MovieId, search: movie.id, batchSize: nil, set: .Movie, doConvert: false)
        
        if results != nil {
            if results?.count > 0 {
                return false
            }
        }
        
        let movieStoreDesc = NSEntityDescription.entityForName("Movie", inManagedObjectContext: managedObjectContext)
        let storeMovie = MovieStore(entity: movieStoreDesc!, insertIntoManagedObjectContext: managedObjectContext)
        
        storeMovie.id = movie.id
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
            storeTrailers(movie.trailers, movie: storeMovie)
            return true
        }
        catch {
            fatalError("Error saving Movie")
        }
    }
    
    private func storeTrailers(trailers: [(title: String, URL: String)], movie: MovieStore) {
        
        for trailer in trailers {
            
            let trailerStoreDesc = NSEntityDescription.entityForName("Trailer", inManagedObjectContext: managedObjectContext)
            let storeTrailer = TrailerStore(entity: trailerStoreDesc!, insertIntoManagedObjectContext: managedObjectContext)
            
            storeTrailer.name = trailer.0
            storeTrailer.url = trailer.1
            storeTrailer.movie = movie
            
            do {
                try managedObjectContext.save()
            }
            catch {
                fatalError("Error saving Tracks")
            }
        }
    }
    
    func storeMusic(music: Music) -> Bool {
        
        let results = searchData(.MusicId, search: music.id, batchSize: nil, set: .Music, doConvert: false)
        
        if results != nil {
            if results?.count > 0 {
                return false
            }
        }
        
        let musicStoreDesc = NSEntityDescription.entityForName("Music", inManagedObjectContext: managedObjectContext)
        let storeMusic = MusicStore(entity: musicStoreDesc!, insertIntoManagedObjectContext:   managedObjectContext)
        
        storeMusic.id = music.id
        storeMusic.title = music.title
        storeMusic.runtime = music.runtime.getTotalInSeconds()
        storeMusic.releaseYear = music.releaseYear
        
        if let owningType = music.owningType {
            storeMusic.owningType = owningType.rawValue
        }
        
        if let ownerLocation = music.ownerLocation {
            storeMusic.ownerLocation = ownerLocation
        }
        
        if let genre = music.genre {
            storeMusic.genre = genre
        }
        
        if let description = music.desc {
            storeMusic.desc = description
        }
        
        if let format = music.format {
            storeMusic.format = format.rawValue
        }
        
        if let coverArt = music.coverArt {
            let imageData = UIImageJPEGRepresentation(coverArt, 1)
            storeMusic.coverArt = imageData
        }
        
        if let albumArtist = music.albumArtist {
            storeMusic.albumArtist = albumArtist
        }
        
        do {
            try managedObjectContext.save()
            storeTracks(music.trackList, music: storeMusic)
            return true
        }
        catch {
            fatalError("Error saving Music")
        }
    }
    
    private func storeTracks(tracks: [Track], music: MusicStore) {

        for track in tracks {
            
            let trackStoreDesc = NSEntityDescription.entityForName("Track", inManagedObjectContext: managedObjectContext)
            let storeTrack = TrackStore(entity: trackStoreDesc!, insertIntoManagedObjectContext: managedObjectContext)
            
            storeTrack.name = track.name
            storeTrack.runtime = track.runtime.getTotalInSeconds()
            storeTrack.trackNr = track.trackNr
            
            storeTrack.album = music
            
            do {
                try managedObjectContext.save()
            }
            catch {
                fatalError("Error saving Tracks")
            }
        }
    }
    
    func storeWishListItem(item: WishListItem) {
        let wishListItemStoreDesc = NSEntityDescription.entityForName("WishListItem", inManagedObjectContext: managedObjectContext)
        let storeItem = WishListStore(entity: wishListItemStoreDesc!, insertIntoManagedObjectContext:   managedObjectContext)
        
        storeItem.id = item.id
        storeItem.aid = item.aid
        storeItem.title = item.title
        storeItem.type = item.type.rawValue
        
        if let detail = item.detail {
            storeItem.detail = detail
        }
        
        if let imgData = item.imageData {
            let data = UIImageJPEGRepresentation(imgData, 1)
            storeItem.imageData = data
        }
        
        do {
            try managedObjectContext.save()
        }
        catch {
            fatalError("Error saving Tracks")
        }
    }
    
    // MARK: - Search
    func searchDatabase(search: DBSearch, doConvert: Bool) -> [AnyObject]? {
        
        switch search.set {
        case .Movie:
            return searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: search.set, doConvert: doConvert)
        case .Music:
            return searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: search.set, doConvert: doConvert)
        case .WishListItem:
            return searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: search.set, doConvert: doConvert)
        case .Union:
            let arrOne = searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: .Movie, doConvert: doConvert)
            let arrTwo = searchData(search.table, search: search.searchString, batchSize: search.batchSize, set: .Music, doConvert: doConvert)
            
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
        default:break
        }
        return nil
    }
    
    private func searchData(table: DBTable?, search: String?, batchSize: Int?, set: SearchSet, doConvert: Bool) -> [AnyObject]? {
        
        let request = NSFetchRequest(entityName: set.rawValue)
        
        if (table != nil) && (search != nil) {
            
            switch table! {
            case .Title:
                request.predicate = NSPredicate(format: "title==%@", search!)
                request.sortDescriptors?.append(NSSortDescriptor(key: "title", ascending: true))
                break
            case .ReleaseYear:
                request.predicate = NSPredicate(format: "releaseYear==%d", Int(search!)!)
                request.sortDescriptors?.append(NSSortDescriptor(key: "releaseYear", ascending: true))
                break
            case .Genre:
                request.predicate = NSPredicate(format: "genre==%@", search!)
                request.sortDescriptors?.append(NSSortDescriptor(key: "genre", ascending: true))
                break
            case .MovieId:
                request.predicate = NSPredicate(format: "id==%@", search!)
                break
            case .MusicId:
                request.predicate = NSPredicate(format: "id==%@", search!)
                break
            case .Id:
                request.predicate = NSPredicate(format: "id==%d", Int(search!)!)
                request.sortDescriptors?.append(NSSortDescriptor(key: "id", ascending: true))
            case .Aid:
                request.predicate = NSPredicate(format: "aid==%@", search!)
                request.sortDescriptors?.append(NSSortDescriptor(key: "aid", ascending: true))
            case .Type:
                request.predicate = NSPredicate(format: "type==%@", search!)
                request.sortDescriptors?.append(NSSortDescriptor(key: "type", ascending: true))
            }

        }
        
        if (batchSize != nil) {
            request.fetchBatchSize = batchSize!
        }
        
        switch set {
        case .Movie:
            var results = [MovieStore]()
            do {
                try results = managedObjectContext.executeFetchRequest(request) as! [MovieStore]
                
                if doConvert {
                    return convertToMovie(results)
                }
                return results
            }
            catch {
                fatalError("Error searching for data")
            }
            break
        case .Music:
            var results = [MusicStore]()
            do {
                try results = managedObjectContext.executeFetchRequest(request) as! [MusicStore]
                
                if doConvert {
                    return convertToMusic(results)
                }
                return results
            }
            catch {
                fatalError("Error searching for data")
            }
            break
        case .WishListItem:
            var results = [WishListStore]()
            do {
                
                try results = managedObjectContext.executeFetchRequest(request) as! [WishListStore]
                if doConvert {
                    return convertToWishListItem(results)
                }
                return results
            }
            catch {
                fatalError("Error searching for data")
            }
        default:break
        }
        
        return nil
    }
    
    private func convertToMovie(data: [MovieStore]) -> [Movie] {
        var movies = [Movie]()
        for mStore in data {
            let movie = Movie(title: mStore.title!, released: Int(mStore.releaseYear!), runtime: Runtime.getRuntimeBasedOnSeconds(Int(mStore.runtime!)))
            
            if let id = mStore.id {
                movie.id = id
            }
            
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
            
            if let rating = mStore.rating {
                movie.rating = Int(rating)
            }
            
            if let trailersSet = mStore.trailers {
                let trailers = trailersSet.allObjects as! [TrailerStore]
                
                for trailer in trailers {
                    movie.trailers.append((trailer.name, trailer.url))
                }
            }
            movie.trailers.sortInPlace({$0.title < $1.title})
            movies.append(movie)
        }
        return movies
    }
    
    private func convertToMusic(data: [MusicStore]) -> [Music] {
    
        var music = [Music]()
        for mStore in data {
            let mu = Music(title: mStore.title!, released: Int(mStore.releaseYear!))
            
            if let id = mStore.id {
                mu.id = id
            }
            
            if let runtime = mStore.runtime {
                mu.runtime = Runtime.getRuntimeBasedOnSeconds(Int(runtime))
            }
            if let genre = mStore.genre {
                mu.genre = genre
            }
            
            if let desc = mStore.desc {
                mu.desc = desc
            }
            
            if let ownerLocation = mStore.ownerLocation {
                mu.ownerLocation = ownerLocation
            }
            
            if (mStore.coverArt != nil) {
                if let coverArt = UIImage(data: mStore.coverArt!) {
                    mu.coverArt = coverArt
                }
            }
            
            if let format = mStore.format {
                mu.setFormat(format)
            }
            
            if let owningType = mStore.owningType {
                mu.setOwningType(owningType)
            }
            
            if let albumArtist = mStore.albumArtist {
                mu.albumArtist = albumArtist
            }
            
            if let rating = mStore.rating {
                mu.rating = Int(rating)
            }
            
            if let trackList = mStore.tracks {
                let tracks = trackList.allObjects as! [TrackStore]
                
                for track in tracks {
                    mu.insertTrack(Track(name: track.name , runtime: Runtime.getRuntimeBasedOnSeconds(Int(track.runtime)), trackNr: Int(track.trackNr)))
                }
            }
            mu.sortAlbum()
            music.append(mu)
        }
        return music
    }
    
    private func convertToWishListItem(data: [WishListStore]) -> [WishListItem] {
        var wishListItems = [WishListItem]()
        
        for item in data {
            var mediaType = MediaType.Music
            
            switch item.type! {
            case "Movie":
                mediaType = .Movie
                break
            case "Music":
                mediaType = .Music
                break
            case "Book":
                mediaType = .Book
                break
            case "Game":
                mediaType = .Game
                break
            default:break
            }
            
            if let data = item.imageData {
                let newItem = WishListItem(id: Int(item.id!), aid: item.aid!, type: mediaType, imageData: UIImage(data: data), title: item.title!, detail: item.detail)
                wishListItems.append(newItem)
            }
        }
        return wishListItems
    }
    
    func removeFromDB(toRemove: DBSearch) {
        var result = searchData(toRemove.table, search: toRemove.searchString, batchSize: nil, set: toRemove.set, doConvert: false)
        
        if result != nil {
            if result!.count > 0 {
                switch toRemove.set {
                case .Movie:
                    managedObjectContext.deleteObject(result![0] as! MovieStore)
                    break
                case .Music:
                    managedObjectContext.deleteObject(result![0] as! MusicStore)
                    break
                case .WishListItem:
                    managedObjectContext.deleteObject(result![0] as! WishListStore)
                    break
                case .Track:
                    managedObjectContext.deleteObject(result![0] as! TrackStore)
                    break
                default:break
                    
                }
                
                do {
                    try managedObjectContext.save()
                }
                catch {
                    fatalError("Error deleting object from core data")
                }
            }
        }
    }
    
    func updateMusicObject(updatedMusic: Music) {
        var result = searchData(.MusicId, search: updatedMusic.id, batchSize: nil, set: .Music, doConvert: false) as! [MusicStore]
        
        if result.count > 0 {
            let managedObject = result[0] as MusicStore
            managedObject.setValue(updatedMusic.title, forKey: "title")
            managedObject.setValue(updatedMusic.genre, forKey: "genre")
            managedObject.setValue(updatedMusic.albumArtist, forKey: "albumArtist")
            managedObject.setValue(updatedMusic.runtime.getTotalInSeconds(), forKey: "runtime")
            //result[0].tracks = NSSet(array: updatedMusic.trackList)
            managedObject.setValue(updatedMusic.releaseYear, forKey: "releaseYear")
            managedObject.setValue(updatedMusic.desc, forKey: "desc")
            managedObject.setValue(updatedMusic.ownerLocation, forKey: "ownerLocation")
            managedObject.setValue(updatedMusic.owningType?.rawValue, forKey: "owningType")
            managedObject.setValue(updatedMusic.format?.rawValue, forKey: "format")
            managedObject.setValue(updatedMusic.rating, forKey: "rating")
            managedObject.setValue(UIImageJPEGRepresentation(updatedMusic.coverArt!, 1), forKey: "coverArt")
            
            do {
                try managedObjectContext.save()
            }
            catch {
                fatalError("Error updating object in core data")
            }
        }
    }
    
    func updateMovieObject(updatedMovie: Movie) {
        var result = searchData(.MovieId, search: updatedMovie.id, batchSize: nil, set: .Movie, doConvert: false) as! [MovieStore]
        
        if result.count > 0 {
            let managedObject = result[0] as MovieStore
            managedObject.setValue(updatedMovie.title, forKey: "title")
            managedObject.setValue(updatedMovie.genre, forKey: "genre")
            managedObject.setValue(updatedMovie.runtime.getTotalInSeconds(), forKey: "runtime")
            managedObject.setValue(updatedMovie.releaseYear, forKey: "releaseYear")
            managedObject.setValue(updatedMovie.desc, forKey: "desc")
            managedObject.setValue(updatedMovie.ownerLocation, forKey: "ownerLocation")
            managedObject.setValue(updatedMovie.owningType?.rawValue, forKey: "owningType")
            managedObject.setValue(updatedMovie.format?.rawValue, forKey: "format")
            managedObject.setValue(updatedMovie.rating, forKey: "rating")
            managedObject.setValue(updatedMovie.director, forKey: "director")
            managedObject.setValue(updatedMovie.mainActors, forKey: "mainActors")
            managedObject.setValue(updatedMovie.ageRestriction, forKey: "ageRestriction")
            managedObject.setValue(UIImageJPEGRepresentation(updatedMovie.coverArt!, 1), forKey: "coverArt")
            
            do {
                try managedObjectContext.save()
            }
            catch {
                fatalError("Error updating object in core data")
            }
        }
    }


    // MARK: - Dev
    func emptyDatabase() {
        let fetchRequest = NSFetchRequest(entityName: "WishListItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.executeRequest(deleteRequest)
        }catch {
            fatalError("Error deleting batabase")
        }
    }
}



