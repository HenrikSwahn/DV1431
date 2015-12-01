//
//  Movie.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-30.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import CoreData

class MovieStore: NSManagedObject {
    @NSManaged var ageRestriction: NSNumber?
    @NSManaged var director: String?
    @NSManaged var mainActors: NSObject?

}
