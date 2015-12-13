//
//  Filter.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-13.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation


class Filter {

    var genre: String?
    var year: Int?
    var rating: Int?
    
    func setFilter(genre: String?, year: String?, rating: String?) {
        self.genre = genre
        
        if let y = year {
            self.year = Int(y)
        }
        
        if let r = rating {
            self.rating = Int(r)
        }
    }
    
    func filterMovies(movies: [Movie]) -> [Movie] {
        return filterMedia(movies) as! [Movie]
    }
    
    func filterMusic(music: [Music]) -> [Music] {
        return filterMedia(music) as! [Music]
    }
    
    private func filterMedia(unFilteredMedia: [Media]) -> [Media] {
        
        var filteredMedia = [Media]()
        for media in unFilteredMedia {
            
            var genrePass = false
            var yearPass = false
            var ratingPass = false
            
            if genre == nil {
                genrePass = true
            }
            else {
                genrePass = checkGenre(media.genre)
            }
            
            if genrePass {
                if year == nil {
                    yearPass = true
                }
                else {
                    yearPass = checkYear(media.releaseYear)
                }
            }
            
            if yearPass {
                if rating == nil {
                    ratingPass = true
                }
                else {
                    ratingPass = checkRating(media.rating)
                }
            }
            
            if genrePass && yearPass && ratingPass {
                filteredMedia.append(media)
            }
        }
        return filteredMedia
    }
    
    private func checkGenre(mediaGenre: String?) -> Bool {
        
        if mediaGenre == nil {
            return false
        }
        
        if mediaGenre?.lowercaseString.rangeOfString(genre!.lowercaseString) != nil {
            return true
        }
        
        return false
    }
    
    private func checkYear(releaseYear: Int?) -> Bool {
        
        if releaseYear == nil {
            return false
        }
        
        if releaseYear! == year {
            return true
        }
        
        return false
    }
    
    private func checkRating(rating: Int?) -> Bool {
        
        if rating == nil {
            return false
        }
        
        if rating! == self.rating! {
            return true
        }
        
        return false
    }
}