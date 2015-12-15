//
//  TrackTableViewCell.swift
//  CombinedTable
//
//  Created by Dino Opijac on 11/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class TrackTableViewCell: ColoredTableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var previewButton: UIButton!
    
    weak var delegate: PlayerPresenter?
    var player: AVPlayer?
    var isPlaying = false
    @IBAction func previewTrackAction(sender: UIButton) {
        
        if !isPlaying {
            delegate?.playMusic!(player!)
            isPlaying = true
            updatePreviewButton()
            previewButton.setNeedsDisplay()
        }
        else {
            delegate?.stopMusic!();
            isPlaying = false
            updatePreviewButton()
            previewButton.setNeedsDisplay()
        }
    }
    
    func updatePreviewButton() {
        
        if isPlaying {
            previewButton.setImage(UIImage(named: "pause"), forState: .Normal)
        }
        else {
            previewButton.setImage(UIImage(named: "play"), forState: .Normal)
        }
        
    }
    
    override func updateUI() {
        if let track = model as? Track {
            self.numberLabel.text = "\(track.trackNr)"
            self.titleLabel.text = track.name
            self.runtimeLabel.text = track.runtime.toTrackString()
            
            if let url = track.url {
                let nsUrl = NSURL(string: url)
                player = AVPlayer(URL: nsUrl!)
            }
            else {
                previewButton.hidden = true
            }
            
            if isPlaying {
                previewButton.titleLabel?.text = "⏸"
            }
            else {
                previewButton.titleLabel?.text = "▶️"
            }
        }
    }
    
    override func updateUIColor() {
        contentView.backgroundColor = self.backgroundUIColor()
        numberLabel.textColor = self.detailUIColor()
        runtimeLabel.textColor = self.detailUIColor()
        titleLabel.textColor = self.primaryUIColor()
    }
}
