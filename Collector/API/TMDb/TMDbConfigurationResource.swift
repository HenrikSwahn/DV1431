//
//  TMDbConfigurationResource.swift
//  Collector
//
//  Created by Dino Opijac on 08/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

public struct TMDbConfigurationResource: APIResource {
    public var resource = URL(pathed: "/3/configuration")

    public init() {}
}