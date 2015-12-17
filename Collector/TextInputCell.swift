//
//  TextInputCell.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-17.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class TextInputCell: ColoredTableViewCell {
    @IBOutlet weak var textInputField: UITextField!

    @IBOutlet weak var keyLabel: UILabel!
    override func updateUI() {
        if let media = model as? KeyValueAdapter {
            keyLabel.text = media.key
            textInputField.text = media.value
        }
    }
    
    override func updateUIColor() {
        self.contentView.backgroundColor = self.backgroundUIColor()
        self.textInputField.textColor = self.primaryUIColor()
    }
}
