//
//  UITableViewCachable.swift
//  Collector
//
//  Created by Dino Opijac on 08/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import UIKit

protocol UITableViewCachable {
    // Needed for storage
    var cachableStore: [String:UIImage]? { get set }
    
    // Called when a row has asynchronously loaded an image
    func cachableTableView(willStore identifier: String, image: UIImage)
    
    // Called when an row wants to know if a identifier was already cached
    func cachableTableView(didStore identifier: String) -> UIImage?
}