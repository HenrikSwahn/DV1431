//
//  GeneralDetailTableViewCell.swift
//  Collector
//
//  Created by Dino Opijac on 13/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class GeneralDetailTableViewCell: ColoredTableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func updateUI() {
        if let general = model as? KeyValueAdapter {
            keyLabel.text = general.key
            valueLabel.text = general.value
            return
        }
    }
    
    override func updateUIColor() {
        contentView.backgroundColor = self.backgroundUIColor()
        keyLabel.textColor = self.detailUIColor()
        valueLabel.textColor = self.primaryUIColor()
    }
}
