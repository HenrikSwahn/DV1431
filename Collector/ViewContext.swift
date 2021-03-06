//
//  Context.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-01.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation

enum ViewContextEnum: String {
    case Movie = "Movie"
    case Music = "Music"
    case EditMovie = "EditMovie"
    case EditMusic = "EditMusic"
    case NewMovie = "NewMovie"
    case NewMusic = "NewMusic"
    case Unkown = "Unkown"
}

protocol ViewContext {
    var context: ViewContextEnum { get set }
}

