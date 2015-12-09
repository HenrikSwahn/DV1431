//
//  TracksTableViewCell.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-09.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class TracksTableViewCell: UITableViewCell {

    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var tracksLabel: UILabel!
    
    func setData(tracks: [Track]) {
        
        
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
