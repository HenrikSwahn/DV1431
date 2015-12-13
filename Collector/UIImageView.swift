//
//  UIImageView.swift
//  CombinedTable
//
//  Created by Dino Opijac on 11/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

public extension UIImageView {
    func dropShadow(colored: UIColor? = nil, offset: CGSize = CGSizeMake(0,0), opacity: Float = 1, radius: CGFloat = 1.0) {
        let color = (colored != nil) ? colored!.CGColor : UIColor.blackColor().CGColor
        
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}