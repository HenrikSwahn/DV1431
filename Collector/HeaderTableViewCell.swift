//
//  HeaderTableViewCell.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-13.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    weak var delegate: FilterDelegate?
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBAction func removeFIlter(sender: UIButton) {
        delegate?.removeFilter()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
