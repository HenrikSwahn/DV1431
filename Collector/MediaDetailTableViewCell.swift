//
//  MediaDetailTableViewCell.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-11-19.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class MediaDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var iconView: UIIconImageView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setImage(named name: String) {
        iconView.setImage(named: name, colored: valueLabel.textColor)
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
            keyLabel.textColor = color.detailColor
            valueLabel.textColor = color.primaryColor.isDarkColor ? color.backgroundColor : color.primaryColor
            iconView.setRenderingMode(withColor: keyLabel.textColor)
        
            if indexPath.row == 0 {
                shadow = color.secondaryColor
            }
        }
    }
}
