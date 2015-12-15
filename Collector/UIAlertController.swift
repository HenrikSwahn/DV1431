//
//  UIAlertController.swift
//  Collector
//
//  Created by Dino Opijac on 15/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addActions(actions: [UIAlertAction]) {
        actions.forEach() { self.addAction($0) }
    }
}