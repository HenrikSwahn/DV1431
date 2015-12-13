//
//  TrackTableViewCell.swift
//  CombinedTable
//
//  Created by Dino Opijac on 11/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class TrackTableViewCell: ColoredTableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    override func updateUI() {
        if let track = model as? Track {
            self.numberLabel.text = "\(track.trackNr)"
            self.titleLabel.text = track.name
            self.runtimeLabel.text = track.runtime.toString()
        }
    }
    
    override func updateUIColor() {
        contentView.backgroundColor = self.backgroundUIColor()
        numberLabel.textColor = self.detailUIColor()
        runtimeLabel.textColor = self.detailUIColor()
        titleLabel.textColor = self.primaryUIColor()
    }
}
