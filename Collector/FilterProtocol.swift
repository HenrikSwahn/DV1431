//
//  FilterProtocol.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-13.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

protocol FilterDelegate: class {
    func didSelectFilter(filter: Filter?);
    func removeFilter();
}