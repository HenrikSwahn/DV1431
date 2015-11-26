//
//  UIIconImageView.swift
//  Collector
//
//  Created by Dino Opijac on 26/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

/*
UIIconImageView changes the rendering behavior of the default UIImageView and
enables tint changes directly from the storboard. UIIconImageView works exactly
as tint colors on navigation items (tab bars, etc.)
*/

class UIIconImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setRenderingMode()
    }
    
    internal func setImage(named name: String) {
        self.image = UIImage(named: name)
    }
    
    internal func setImage(named name: String, colored color: UIColor) {
        self.setImage(named: name)
        self.setRenderingMode(withColor: color)
    }
    
    internal func setRenderingMode() {
        self.image = self.image?.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    internal func setRenderingMode(withColor color: UIColor) {
        self.tintColor = color
        self.setRenderingMode()
    }
}
