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
    
    static func getRuntimeBasedOnSeconds(seconds:Int) -> Runtime {
        let sec = seconds % 60
        let totalMin = seconds / 60
        let min = totalMin % 60
        let hour = totalMin / 60
        
        return Runtime(hours: hour, minutes: min, seconds: sec)
    }
    
    static func getRuntimeBasedOnFormattedString(time: String) -> Runtime {
        let timeArr = time.characters.split{ $0 == " " }.map{String($0)}
        var hours = 0;
        var min = 0;
        var sec = 0;
        
        for var i = 0; i < timeArr.count; ++i {
            if let intVal = Int(timeArr[i]) {
                if i == 0 {
                    hours = intVal
                }
                else if i == 2 {
                    min = intVal
                }
                else if i == 4 {
                    sec = intVal
                }
            }
        }
        return Runtime(hours: hours, minutes: min, seconds: sec)
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
