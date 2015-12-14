//
//  TrailerStore.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-14.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

import CoreData

class TrailerStore: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var url: String
    @NSManaged var movie: MovieStore
}