//
//  WishListRectangleTableViewCell.swift
//  Collector
//
//  Created by Dino Opijac on 09/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class WishListRectangleTableViewCell: UITableViewCell {
    var wish: WishListItem? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var wishIconType: UIIconImageView!
    @IBOutlet weak var wishImageView: UIImageView!
    @IBOutlet weak var wishTitleLabel: UILabel!
    
    func updateUI() {
        if let item = wish {
            if let imageData = item.imageData {
                self.wishImageView.image = imageData
            }
            
            wishIconType.image = getType(item)
            wishTitleLabel?.text = item.title
        }
    }
    
    func getType(item: WishListItem) -> UIImage? {
        switch item.type {
            case .Book: return UIImage(named: "book")
            case .Game: return UIImage(named: "joystick")
            case .Movie: return UIImage(named: "film")
            case .Music: return UIImage(named: "music")
        }
    }
}
