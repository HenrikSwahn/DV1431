//
//  ValueDetailCell.swift
//  CombinedTable
//
//  Created by Dino Opijac on 13/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class ValueTableViewCell: ColoredTableViewCell {
    @IBOutlet weak var valueCell: UILabel!
    
    override func updateUI() {
        if let movie = model as? ValueAdapter {
            valueCell.text = movie.value
        }
    }
    
    override func updateUIColor() {
        self.contentView.backgroundColor = self.backgroundUIColor()
        self.valueCell.textColor = self.primaryUIColor()
    }
}
