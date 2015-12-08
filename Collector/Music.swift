//
//  Music.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-26.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

class Music: Media {
    
    var albumArtist: String?
    var trackList = [Track]() {
        didSet {
            calculateAlbumLength()
        }
    }
    
    init(title: String, released: Int) {
        super.init(title: title, released: released, runtime: Runtime(hours: 0, minutes: 0, seconds: 0))
    }
    
    private func calculateAlbumLength() -> Runtime {
        
        let timeInSeconds = Array(trackList).reduce(0) {(total, obj) in total + obj.runtime.getTotalInSeconds()}
        return super.runtime.setTimeBasedOnSeconds(timeInSeconds)
    }
    
    func sortAlbum() {
        trackList.sortInPlace({$0.trackNr < $1.trackNr})
        
        for track in trackList {
            print(track.name)
        }
    }
    
    func insertTrack(aTrack: Track) {
        trackList.append(aTrack)
    }
    
    // MARK: - toDict
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
        
        if let artist = self.albumArtist {
            movieDict["albumArtist"] = artist
        }
        
        return movieDict
    }
}