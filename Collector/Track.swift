//
//  Track.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-26.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

class Track {
    
    private var name: String
    private var runtime:Runtime
    
    init(name: String, runtime: Runtime) {
        self.name = name
        self.runtime = runtime
    }
    
    func getRuntimeInSeconds() -> Int {
            return runtime.getTotalInSeconds()
    }
    
    func getRuntime() -> Runtime {
        return runtime
    }
    
    func getName() -> String? {
        return name
    }
    
    func setRuntime(runtime: Runtime) {
        self.runtime = runtime
    }
    
    func setName(name: String) {
        self.name = name
    }
}