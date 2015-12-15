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
    private var url: String?
    @IBAction func previewTrackAction(sender: UIButton) {
        delegate?.playMusic!(self.url!)
    }
    
    override func updateUI() {
        if let track = model as? Track {
            self.numberLabel.text = "\(track.trackNr)"
            self.titleLabel.text = track.name
            self.runtimeLabel.text = track.runtime.toTrackString()
            
            if let url = track.url {
                self.url = url
            }
            else {
                previewButton.hidden = true
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
