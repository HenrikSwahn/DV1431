//
//  TrackStore.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-08.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import CoreData

class TrackStore: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var runtime: NSNumber?
    @NSManaged var album: MusicStore?
}