//
//  Music.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-07.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import CoreData


class MusicStore: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var runtime: NSNumber?
    @NSManaged var releaseYear: NSNumber?
    @NSManaged var owningType: String?
    @NSManaged var ownerLocation: String?
    @NSManaged var genre: String?
    @NSManaged var format: String?
    @NSManaged var desc: String?
    @NSManaged var coverArt: NSData?
    @NSManaged var albumArtist: String?
    @NSManaged var tracks: NSSet?
    @NSManaged var rating: NSNumber?
}
