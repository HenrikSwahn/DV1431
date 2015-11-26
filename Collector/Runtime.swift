//
//  Runtime.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-26.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

class Runtime {
    
    private var hours = 0
    private var minutes = 0
    private var seconds = 0
    
    init(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    func getTotalInSeconds() -> Int {
        return ((hours * 3600) + (minutes * 60) + seconds)
    }
    
    func setTimeBasedOnSeconds(seconds:Int) -> Runtime {
        self.seconds = seconds % 60
        let totalMin = seconds / 60
        self.minutes = totalMin % 60
        self.hours = totalMin / 60
        
        return self
    }
    
    func toString() -> String {
        
        var retString = ""
        if hours > 0 {
            retString += "\(hours)h "
        }
        
        if minutes > 0 {
            retString += "\(minutes)m"
        }
        
        if seconds > 0 {
            retString += " \(seconds)s"
        }
        
        return retString
    }
}
