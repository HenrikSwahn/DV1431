//
//  TMDbConfigurationResource.swift
//  Collector
//
//  Created by Dino Opijac on 05/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

public struct TMDbMovieResource: APIResource {
    public var resource = URL(pathed: "")
    
    public init(id: String) {
        resource.urlPath(pathed: "/3/movie/%@", args: id)
        resource.urlField(named: "append_to_response", "credits,videos")
    }
}