//
//  Media.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-30.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import CoreData

class MediaStore: NSManagedObject {
    @NSManaged var coverArt: NSData?
    @NSManaged var desc: String?
    @NSManaged var format: String?
    @NSManaged var genre: String?
    @NSManaged var ownerLocation: String?
    @NSManaged var owningType: String?
    @NSManaged var releaseYear: NSNumber?
    @NSManaged var runtime: NSNumber?
    @NSManaged var title: String?
}
