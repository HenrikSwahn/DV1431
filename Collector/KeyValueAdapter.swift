//
//  ValueKeyAdapter.swift
//  CombinedTable
//
//  Created by Dino Opijac on 13/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

class KeyValueAdapter {
    var key: String
    var value: String?
    
    init(_ key: String, _ value: String?) {
        self.key = key
        self.value = value
    }
}

class ValueAdapter {
    var value: String?
    
    init(_ value: String?) {
        self.value = value
    }
}