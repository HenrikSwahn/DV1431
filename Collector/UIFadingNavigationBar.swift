//
//  UIFadingNavigationBar.swift
//  Collector
//
//  Created by Dino Opijac on 17/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class UIFadingNavigationBar: UINavigationBar {
    var view: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = UIView(frame: CGRectMake(0, -20, UIScreen.mainScreen().bounds.size.width, CGRectGetHeight(self.bounds)+20))
        view!.userInteractionEnabled = false
        //self.overlay.backgroundColor = colors?.backgroundColor
        insertSubview(view!, atIndex: 0)
    }
    
    override var backgroundColor: UIColor? {
        get {
            return view?.backgroundColor
        }
        
        set {
            view?.backgroundColor = backgroundColor
        }
    }
    
    override var alpha: CGFloat {
        get {
            if view != nil {
                return view!.alpha
            } else {
                return self.alpha
            }
        }
        set {
            view?.alpha = newValue
        }
    }
}