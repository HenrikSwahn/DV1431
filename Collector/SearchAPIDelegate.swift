//
//  SearchAPIDelegate.swift
//  Collector
//
//  Created by Dino Opijac on 07/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

public protocol SearchAPIDelegate {
    func searchAPI(count: Int)
    func searchAPI(didFail error: NSError)
}