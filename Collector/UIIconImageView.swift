//
//  UIIconImageView.swift
//  Collector
//
//  Created by Dino Opijac on 26/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class UIIconImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.image = self.image?.imageWithRenderingMode(.AlwaysTemplate)
    }
}
