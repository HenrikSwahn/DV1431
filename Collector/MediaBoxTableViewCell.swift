//
//  MediaBoxTableViewCell.swift
//  Collector
//
//  Created by Dino Opijac on 13/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MediaBoxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    var media: Music? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let music = media {
            mediaImageView.image = music.coverArt
            
            primaryLabel.text = music.title ?? ""

            secondaryLabel.text! = "\(music.runtime.toTrackString()) • \(music.trackList.count) tracks"

            detailsLabel.text = "\(music.releaseYear)"
        }
    }
}
