//
//  TrackTableViewCell.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-10.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    private let cellSeparatorWeight: CGFloat = 0.5
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var shadow: UIColor? {
        willSet {
            let shadowLayer = CAGradientLayer()
            shadowLayer.frame = CGRectMake(0, 0, frame.width, 2)
            shadowLayer.colors = [newValue!.CGColor, UIColor.clearColor().CGColor]
            shadowLayer.opacity = 0.5
            contentView.layer.addSublayer(shadowLayer)
        }
    }
    
    func setDominantColors(with colors: UIImageColors?, indexPath: NSIndexPath) {
        if let color = colors {
            backgroundColor = color.secondaryColor
            contentView.backgroundColor = color.secondaryColor
            nameLabel.textColor = color.detailColor
            lengthLabel.textColor = color.detailColor
            
            if indexPath.row == 0 {
                shadow = color.secondaryColor
            } else {
                let separatorView = UIView(frame: CGRectMake(0, 0, self.bounds.width, self.cellSeparatorWeight))
                separatorView.backgroundColor = color.detailColor
                self.contentView.addSubview(separatorView)
            }
        }
    }

}
