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
    
    func storeMedia(title: String, genre: String, releaseYear: Int, owningType: String?, ownerLocation: String?, format: String?, runtime: Int?, description: String?, coverArt: UIImage?) -> Bool {
        
        let mediaStoreDesc = NSEntityDescription.entityForName("Media", inManagedObjectContext: managedObjectContext)
        let storeMedia = MediaStore(entity: mediaStoreDesc!, insertIntoManagedObjectContext: managedObjectContext)
        
        storeMedia.title = title
        storeMedia.genre = genre
        storeMedia.releaseYear = releaseYear
        
        if (owningType != nil) {
            storeMedia.owningType = owningType
        }
        
        if (ownerLocation != nil) {
            storeMedia.ownerLocation = ownerLocation
        }
        
        if (format != nil) {
            storeMedia.format = format
        }
        
        if (runtime != nil) {
                storeMedia.runtime = runtime
        }
        
        if (description != nil) {
                storeMedia.desc = description
        }
        
        if (coverArt != nil) {
                let imageData = UIImageJPEGRepresentation(coverArt!, 1)
                storeMedia.coverArt = imageData
        }
        
        
        do {
            try managedObjectContext.save()
        }
        catch {
            return false
        }
        return true
    }
    
    func getMedia() -> [Media]? {
        var storedMedias = [MediaStore]()
        
        let request = NSFetchRequest(entityName: "Media")
        
        do {
            try storedMedias = managedObjectContext.executeFetchRequest(request) as! [MediaStore]
            var medias = [Media]()
            for mStore in storedMedias {
                let rt = Runtime(hours: 0, minutes: 0, seconds: 0)
                rt.setTimeBasedOnSeconds(Int(mStore.runtime!))
                let media = Media(title: mStore.title!, released: Int(mStore.releaseYear!), runtime: rt)
                media.setGenre(mStore.genre!)
                media.setDescription(mStore.desc!)
                media.setOwnerLocation(mStore.ownerLocation!)
                media.setCoverArt(UIImage(data: mStore.coverArt!)!)
                
                switch(mStore.owningType!) {
                case "Physical":
                    media.setOwningType(.Physical)
                    break
                case "Digital":
                    media.setOwningType(.Physical)
                    break
                default:
                    media.setOwningType(.NotOwned)
                    break
                }
                
                switch(mStore.format!) {
                    case "DVD":
                        media.setFormat(.DVD)
                        break
                    case "Blu-Ray":
                        media.setFormat(.BLURAY)
                        break
                    case "VHS":
                        media.setFormat(.VHS)
                        break
                    case "MP4":
                        media.setFormat(.MP4)
                        break
                    case "CD":
                        media.setFormat(.CD)
                        break
                    case "MP3":
                        media.setFormat(.MP3)
                        break
                    case "Flac":
                        media.setFormat(.FLAC)
                        break
                default:
                    media.setFormat(.DVD)
                    break
                }
                medias.append(media)
            }
            return medias
        }    
        catch {
            fatalError("Could not execute query")
        }
    }
}