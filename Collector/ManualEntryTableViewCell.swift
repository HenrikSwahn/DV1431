//
//  ManualEntryTableViewCell.swift
//  Collector
//
//  Created by Dino Opijac on 20/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class ManualEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var genricEntryTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
