//
//  TMDbConfigurationItem.swift
//  Collector
//
//  Created by Dino Opijac on 08/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

public struct TMDbConfigurationItem {
    var baseURL: String
    var baseURLSecured: String
    var shouldUpdate: NSTimeInterval
    var poster: [String:String]
    
    public init(baseURL: String, baseURLSecured: String) {
        self.baseURL = baseURL
        self.baseURLSecured = baseURLSecured
        self.shouldUpdate = NSDate().timeIntervalSince1970 + TMDb.Configuration.UpdateInterval
        self.poster = [String:String]()
        self.poster["xxs"] = "w92"
        self.poster["xs"]  = "w154"
        self.poster["s"]   = "w185"
        self.poster["m"]   = "w342"
        self.poster["l"]   = "w500"
        self.poster["xl"]  = "w780"
        self.poster["xxl"] = "original"
    }
    
    public static func defaultConfiguration() -> TMDbConfigurationItem {
        return self.init(baseURL: "http://image.tmdb.org/t/p/", baseURLSecured: "https://image.tmdb.org/t/p/")
    }
    
    public static func fromUserDefaults() -> TMDbConfigurationItem? {
        let defaults = NSUserDefaults()
        
        if let dict = defaults.objectForKey(TMDb.Configuration.Key) {
            var item = defaultConfiguration()
                item.propertyList = dict
            print(item)
            return item
        }
        
        return nil
    }

    public func shouldUpdateTimeInterval() -> Bool {
        let currentTime = NSDate().timeIntervalSince1970
        let distance = currentTime.distanceTo(self.shouldUpdate)
        print("WARNING: TMDb.Configuration: is set to \(TMDb.Configuration.UpdateInterval)")
        print("Next update: \(distance)")
        return distance <= 0
    }
    
    var propertyList: AnyObject {
        get {
            return  [
                "baseURL": self.baseURL,
                "baseURLSecured": self.baseURLSecured,
                "shouldUpdate": String(self.shouldUpdate),
            ]
        }
        set {
            if let dict = newValue as? [String:AnyObject] {
                if let baseURL = dict["baseURL"] as? String {
                    self.baseURL = baseURL
                }
                
                if let baseURLSecured = dict["baseURLSecured"] as? String {
                    self.baseURLSecured = baseURLSecured
                }
                
                if let interval = dict["shouldUpdate"] as? String {
                    if let time = NSTimeInterval(interval) {
                        self.shouldUpdate = time
                    }
                }
            }
        }
    }
}