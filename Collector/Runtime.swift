//
//  Runtime.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-26.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

public class Runtime {
    
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
    
    static func getRuntimeBasedOnMinutes(minutes: Int) -> Runtime {
        let hours = minutes / 60
        let min = minutes % 60
        
        return Runtime(hours: hours, minutes: min, seconds: 0)
    }
    
    static func getRuntimeBasedOnString(time: String) -> Runtime {
        
        let timeArr = time.characters.split{ $0 == " "}.map{String($0)}
        
        var hours = 0;
        var min = 0;
        var sec = 0;
        
        for var i = 0; i < timeArr.count; ++i {
            let truncated = timeArr[i].substringToIndex(timeArr[i].endIndex.predecessor())
            
            if let intVal = Int(truncated) {
                if i == 0 {
                    hours = intVal
                }
                else if i == 1 {
                    min = intVal
                }
                else {
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
    
    func toTrackString() -> String {
        switch (hours, minutes, seconds) {
            case (0, let m, let s):         return String(format: "%02d:%02d", m, s)
            case (0, 0, let s) where s > 0: return String(format: "00:%02d", s)
            case (let h, 0, let s):         return String(format: "%02d:00:%02d", h, s)
            case (let h, let m, let s):     return String(format: "%02d:%02d:%02d", h, m, s)
        }
    }
}

public protocol RuntimeFormatable: CustomStringConvertible {
    var runtime: Runtime { get set }
}

public class RuntimeTrackFormatter: RuntimeFormatable {
    public var runtime: Runtime
    
    public var description: String {
        var fmt = ""
        fmt += format(0, runtime.hours)
        fmt += format(runtime.hours, runtime.minutes)
        fmt += format(runtime.minutes, runtime.hours)
        return fmt
    }
    
    private func format(first: Int, _ second: Int) -> String {
        switch (first, second) {
            case (0, let s) where s > 0: // 0 1
                return "\(s)"
            case (let m, let s) where m > 0 && s > 0: // 1 1 -> :1
                return ":\(s)"
            default:
                return ""
        }
    }
    
    required public init(runtime: Runtime) {
        self.runtime = runtime
    }
}