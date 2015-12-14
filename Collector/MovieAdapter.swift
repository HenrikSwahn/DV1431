//
//  MovieAdapter.swift
//  CombinedTable
//
//  Created by Dino Opijac on 13/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

struct MovieAdapter {
    private struct Section {
        static var General: String = "General"
        static var Ownership: String = "Ownership"
        static var Description: String = "Description"
        static var People: String = "People"
        static var Video: String = "Videos"
    }
    
    private static func getString(str: String?) -> String {
        if let s = str {
            if s.characters.count > 0 {
                return s
            }
        }
        
        return "Not set"
    }
    
    private static func ownership(movie: Movie) -> [AnyObject] {
        let type = getString(movie.owningType?.rawValue)
        let location = getString(movie.ownerLocation)
        
        return [
            Section.Ownership,
            KeyValueAdapter("Type", type),
            KeyValueAdapter("Location", location)
        ]
    }
    
    private static func general(movie: Movie) -> [AnyObject] {
        return [
            Section.General,
            KeyValueAdapter("Format", movie.format?.rawValue),
            KeyValueAdapter("Runtime", movie.runtime.toString()),
            KeyValueAdapter("Genre", movie.genre),
            KeyValueAdapter("Release", String(movie.releaseYear)),
        ]
    }
    
    private static func desc(movie: Movie) -> [AnyObject] {
        return [
            Section.Description,
            ValueAdapter(movie.desc)
        ]
    }
    
    private static func people(movie: Movie) -> [AnyObject] {
        return [
            Section.People,
            KeyValueAdapter("Actor(s)", movie.mainActors),
            KeyValueAdapter("Director(s)", movie.director)
        ]
    }
    
    private static func videos(movie: Movie) -> [AnyObject] {
        return [
            Section.Video,
            KeyValueAdapter("trailer name", "link to youtube"),
            KeyValueAdapter("trailer name", "link to youtube"),
            KeyValueAdapter("trailer name", "link to youtube")
        ]
    }
    
    static func tableView(movie: Movie) -> [[AnyObject]] {
        var adapter = [[AnyObject]]()
        adapter.append(MovieAdapter.desc(movie))
        adapter.append(MovieAdapter.people(movie))
        adapter.append(MovieAdapter.general(movie))
        adapter.append(MovieAdapter.ownership(movie))
        adapter.append(MovieAdapter.videos(movie))
        
        return adapter
    }
    
}