//
//  WishListItem.swift
//  Collector
//
//  Created by Dino Opijac on 10/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import UIKit

enum MediaType: String {
    case Movie  = "Movie"
    case Music  = "Music"
    case Game   = "Game"
    case Book   = "Book"
}

class WishListItem {
    // ID for the item in CoreData?
    var id: Int
    
    // ID for the item in the API
    var aid: String
    
    // Type of media
    var type: MediaType
    
    // The cover art for the media
    var imageData: UIImage?
    
    // Title for the item
    // Movie: This is should contain the title of the movie
    // Album: This is should contain the title of the album
    // Game: This should contain then name of the game
    // Book: This should contain the title of the book
    var title: String
    
    // Detail
    // Movie: This should be empty (optional)
    // Album: This should contain the artist
    // Game: This should be empty
    // Book: This should contain author
    var detail: String?
    
    init(id: Int, aid: String, type: MediaType, imageData: UIImage?, title: String, detail: String?) {
        self.id = id
        self.aid = aid
        self.type = type
        self.imageData = imageData
        self.title = title
        self.detail = detail
    }
}