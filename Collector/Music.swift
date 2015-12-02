//
//  Music.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-26.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

class Music: Media {
    
    private var albumArtist: String?
    private var trackList = [Track]() {
        didSet {
            //super.setRuntime(calculateAlbumLength())
        }
    }
    
    init(title: String, released: Int, artist: String?) {
        super.init(title: title, released: released, runtime: Runtime(hours: 0, minutes: 0, seconds: 0))
        
        if let art = artist {
            self.albumArtist = art
        }
        
        self.insertTrack(Track(name: "1", runtime: Runtime(hours: 0, minutes: 3, seconds: 3)))
        self.insertTrack(Track(name: "1", runtime: Runtime(hours: 0, minutes: 3, seconds: 3)))
        self.insertTrack(Track(name: "1", runtime: Runtime(hours: 0, minutes: 3, seconds: 3)))
        self.insertTrack(Track(name: "1", runtime: Runtime(hours: 0, minutes: 3, seconds: 3)))
        self.insertTrack(Track(name: "1", runtime: Runtime(hours: 0, minutes: 3, seconds: 3)))
        print(super.getRuntime().toString())
    }
    
    private func calculateAlbumLength() -> Runtime {
        
        let timeInSeconds = Array(trackList).reduce(0) {(total, obj) in total + obj.getRuntimeInSeconds()}
        return super.getRuntime().setTimeBasedOnSeconds(timeInSeconds)
    }
    
    // MARK: - Setters
    func insertTrack(aTrack: Track) {
        trackList.append(aTrack)
    }
    
    func setAlbumArtist(name: String) {
        albumArtist = name
    }
    
    // MARK: - Getters
    func getAlbumArtist() -> String? {
        return albumArtist
    }
    
    func getAlbumTracks() -> [Track] {
        return trackList
    }
    
    // MARK: - toDict
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
        
        if let artist = self.albumArtist {
            movieDict["albumArtist"] = artist
        }
        
        return movieDict
    }
}