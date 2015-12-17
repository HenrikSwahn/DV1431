//
//  AlbumDetail.swift
//  CombinedTable
//
//  Created by Dino Opijac on 12/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

enum AlbumSection {
    case General
    case Ownership
    case Tracks
}

struct AlbumAdapter {
    private struct Section {
        static var General: String = "General"
        static var Ownership: String = "Ownership"
        static var Tracks: String = "Tracks"
        static var Regular: String = "Regular"
        static var Picker: String = "Picker"
    }
    
    private static func ownership(music: Music) -> [AnyObject] {
        let type = getString(music.owningType?.rawValue)
        let location = getString(music.ownerLocation)
        
        return [
            Section.Ownership,
            KeyValueAdapter("Type", type),
            KeyValueAdapter("Location", location)
        ]
    }
    
    private static func general(album: Music) -> [AnyObject] {
        
        return [
            Section.General,
            KeyValueAdapter("Format", album.format?.rawValue),
            KeyValueAdapter("Runtime", album.runtime.toTrackString()),
            KeyValueAdapter("Genre", album.genre),
            KeyValueAdapter("Release", String(album.releaseYear)),
            KeyValueAdapter("Tracks", String(album.trackList.count))
        ]
    }
    
    private static func tracks(album: Music) -> [AnyObject] {
        var tracks: [AnyObject] = album.trackList
        tracks.insert(Section.Tracks, atIndex: 0)
        return tracks
    }
    
    private static func picker(album: Music) -> [AnyObject] {
        
        let type = getString(album.owningType?.rawValue)
        
        return [
            Section.Picker,
            KeyValueAdapter("Format", album.format?.rawValue),
            KeyValueAdapter("Runtime", album.runtime.toTrackString()),
            KeyValueAdapter("Release", String(album.releaseYear)),
        ]
    }
    
    private static func regular(album: Music) -> [AnyObject] {
        
        let location = getString(album.ownerLocation)
        return [
            Section.Regular,
            KeyValueAdapter("Genre", album.genre),
            KeyValueAdapter("Location", location),
            KeyValueAdapter("Tracks", String(album.trackList.count))
        ]
    }
    
    static func tableView(album: Music) -> [[AnyObject]] {
        var adapter = [[AnyObject]]()
        adapter.append(AlbumAdapter.general(album))
        adapter.append(AlbumAdapter.ownership(album))
        
        let tracks = AlbumAdapter.tracks(album)
        
        if tracks.count > 1 {
            adapter.append(AlbumAdapter.tracks(album))
        }
        
        
        return adapter
    }
    
    static func getSectionPosition(section: AlbumSection) -> Int {
        switch(section) {
        case .General:
            return 0
        case .Ownership:
            return 1
        case .Tracks:
            return 2
        }
    }

    private static func getString(str: String?) -> String {
        if let s = str {
            if s.characters.count > 0 {
                return s
            }
        }
        
        return "Not set"
    }
    
    static func getAddMovieAdapter(music: Music) -> [[AnyObject]] {
        
        var adapter = [[AnyObject]]()
        
        adapter.append(AlbumAdapter.regular(music))
        adapter.append(AlbumAdapter.picker(music))
        
        return adapter
    }
}