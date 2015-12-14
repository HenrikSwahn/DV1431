//
//  AlbumDetail.swift
//  CombinedTable
//
//  Created by Dino Opijac on 12/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

struct AlbumAdapter {
    private struct Section {
        static var General: String = "General"
        static var Ownership: String = "Ownership"
        static var Tracks: String = "Tracks"
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
    
    static func tableView(album: Music) -> [[AnyObject]] {
        var adapter = [[AnyObject]]()
        adapter.append(AlbumAdapter.general(album))
        adapter.append(AlbumAdapter.ownership(album))
        adapter.append(AlbumAdapter.tracks(album))
        
        return adapter
    }
    
    private static func getString(str: String?) -> String {
        if let s = str {
            if s.characters.count > 0 {
                return s
            }
        }
        
        return "Not set"
    }
}