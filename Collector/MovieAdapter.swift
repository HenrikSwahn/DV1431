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
        static var Regular: String = "Regular"
        static var Picker: String = "Picker"
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
            KeyValueAdapter("Format", getString(movie.format?.rawValue)),
            KeyValueAdapter("Runtime", getString(movie.runtime.toString())),
            KeyValueAdapter("Genre", getString(movie.genre)),
            KeyValueAdapter("Release", String(movie.releaseYear)),
        ]
    }
    
    private static func desc(movie: Movie) -> [AnyObject] {
        return [
            Section.Description,
            ValueAdapter(getString(movie.desc))
        ]
    }
    
    private static func people(movie: Movie) -> [AnyObject] {
        return [
            Section.People,
            KeyValueAdapter("Actor(s)", getString(movie.mainActors)),
            KeyValueAdapter("Director(s)", getString(movie.director))
        ]
    }
    
    private static func videos(movie: Movie) -> [AnyObject] {
        var videos: [AnyObject] = movie.trailers.map({ KeyValueAdapter($0.title, $0.URL) })
        videos.insert(Section.Video, atIndex: 0)
        return videos
    }
    
    private static func regular(movie: Movie) -> [AnyObject] {
    
        let location = getString(movie.ownerLocation)
        return [
        Section.Regular,
        KeyValueAdapter("Actor(s)", getString(movie.mainActors)),
        KeyValueAdapter("Director(s)", getString(movie.director)),
        KeyValueAdapter("Genre", getString(movie.genre)),
        KeyValueAdapter("Location", location),
        ]
    }
    private static func picker(movie: Movie) -> [AnyObject] {
        
        let type = getString(movie.owningType?.rawValue)
        
        return [
            Section.Picker,
            KeyValueAdapter("Type", type),
            KeyValueAdapter("Format", getString(movie.format?.rawValue)),
            KeyValueAdapter("Runtime", getString(movie.runtime.toString())),
            KeyValueAdapter("Release", String(movie.releaseYear))
        ]
    }

    static func tableView(movie: Movie) -> [[AnyObject]] {
        var adapter = [[AnyObject]]()
        
        adapter.append(MovieAdapter.desc(movie))
        adapter.append(MovieAdapter.people(movie))
        adapter.append(MovieAdapter.general(movie))
        adapter.append(MovieAdapter.ownership(movie))
        
        let videos = MovieAdapter.videos(movie)

        if videos.count > 1 {
            adapter.append(MovieAdapter.videos(movie))
        }
        return adapter
    }
    
    static func getAddMovieAdapter(movie: Movie) -> [[AnyObject]] {
    
        var adapter = [[AnyObject]]()
        
        adapter.append(MovieAdapter.regular(movie))
        adapter.append(MovieAdapter.picker(movie))
        
        return adapter
    }
    
}