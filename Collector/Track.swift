//
//  Track.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-26.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

class Track: NSObject {
    
    var name: String
    var runtime:Runtime
    
    init(name: String, runtime: Runtime) {
        self.name = name
        self.runtime = runtime
        super.init()
    }
}