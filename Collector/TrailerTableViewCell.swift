//
//  TrailerTableViewCell.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-14.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class TrailerTableViewCell: ColoredTableViewCell {
    
    weak var delegate: PlayerPresenter? {
        didSet {
            updateUI()
        }
    }
    
    override func updateUI() {
        if let data = model {
            print("Adding data here")
        }
    }
    
    override func updateUIColor() {
        contentView.backgroundColor = self.backgroundUIColor()
        titleLabel.textColor = self.primaryUIColor()
        playButton.tintColor = self.secondaryUIColor()
    }
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func playTrailer(sender: UIButton) {
        
        let videoURL = NSURL(string: "https://www.youtube.com/watch?v=Aj7ty6sViiU")
        playVideoWithYoutubeURL(videoURL!)
    }
    
    func playVideoWithYoutubeURL(url: NSURL) {
        Youtube.h264videosWithYoutubeURL(url, completion: { (videoInfo, error) -> Void in
            if let
                videoURLString = videoInfo?["url"] as? String,
                _ = videoInfo?["title"] as? String {
                    let url = NSURL(string: videoURLString)
                    let player = AVPlayer(URL: url!)
                    let playerVC = AVPlayerViewController()
                    playerVC.player = player
                    self.delegate?.presentPlayer(playerVC)
            }
        })
    }
}
