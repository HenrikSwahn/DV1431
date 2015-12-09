//
//  WishListStore.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-09.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import CoreData

class WishListStore: NSManagedObject {
    @NSManaged var id: NSNumber?
    @NSManaged var aid: String?
    @NSManaged var type: String?
    @NSManaged var imageData: NSData?
    @NSManaged var title: String?
    @NSManaged var detail: String?
}
