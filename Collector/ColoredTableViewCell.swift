//
//  SectionTableViewCell.swift
//  CombinedTable
//
//  Created by Dino Opijac on 13/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class ColoredTableViewCell: UITableViewCell {
    
    var model: AnyObject? {
        didSet {
            updateUI()
        }
    }
    
    var colors: UIImageColors? {
        didSet {
            updateUIColor()
        }
    }
    
    func primaryUIColor() -> UIColor? { return colors?.secondaryColor }
    func secondaryUIColor() -> UIColor? { return colors?.primaryColor }
    func detailUIColor() -> UIColor? { return colors?.detailColor }
    func backgroundUIColor() -> UIColor? { return colors?.backgroundColor?.colorWithMinimumSaturation(0.15) }
    
    func updateUI() {}
    func updateUIColor() {}
}
