//
//  MovieTableViewCell.swift
//  Collector
//
//  Created by Dino Opijac on 13/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MediaRectangleTableViewCell: UITableViewCell {

    var media: Movie? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var detaiLabel: UILabel!
    
    func updateUI() {
        if let item = media {
            mediaImageView.image = item.coverArt
            
            primaryLabel.text = item.title
            secondaryLabel.text = "\(item.runtime.toString()) • "

            if let description = item.desc {
                secondaryLabel.text! += description
            }
            
            detaiLabel.text = "\(item.releaseYear)"
        }
    }
}
