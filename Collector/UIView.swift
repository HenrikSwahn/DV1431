//
//  UIView.swift
//  Collector
//
//  Created by Dino Opijac on 17/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

extension UIView {
    enum UIViewSeparator {
        case Top
        case Bottom
    }
    
    static func separatorMake(type: UIViewSeparator, rect: CGRect) -> UIView {
        let thickness: CGFloat = (1.0 / UIScreen.mainScreen().scale)
        
        let separator = UIView(
            frame: CGRectMake(
                rect.origin.x,
                type == .Bottom ? (rect.size.height - thickness) : thickness,
                rect.size.width,
                thickness)
        )
        
        return separator
    }
}
