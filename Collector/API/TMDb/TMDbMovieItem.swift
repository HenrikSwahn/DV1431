//
//  TMDbConfigurationResource.swift
//  Collector
//
//  Created by Dino Opijac on 05/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

public struct TMDbMovieItem {
    var id: String
    var image: String
    var release: Int
    var language: String
    var title: String
    var synopsis: String
    var runtime: Int
    var cast: [String]
    var genres: [String]
}