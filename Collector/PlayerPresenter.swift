//
//  PlayerPresenter.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-14.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import Foundation
import AVKit

@objc protocol PlayerPresenter: class {
    optional func presentPlayer(playerVC: AVPlayerViewController)
    optional func playMusic(url: String)
    optional func stopMusic()
}