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
        self.image = self.image?.imageWithRenderingMode(.AlwaysTemplate)
    }
}
