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
    var runtime: Runtime
    var trackNr: Int
    var url: String?
    
    init(name: String, runtime: Runtime, trackNr: Int, url: String?) {
        self.name = name
        self.runtime = runtime
        self.trackNr = trackNr
        self.url = url
        super.init()
    }
}