//
//  ManualEntryTableViewCell.swift
//  Collector
//
//  Created by Dino Opijac on 20/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class ManualEntryTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var trackName: UITextField! {
        didSet {
            self.trackName.delegate = self
        }
    }
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var trackRunTime: UIPickerTextField! {
        didSet {
            var seconds: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
                (second, _) -> String in return "\(second)s"
            })
            
            var minutes: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
                (min, _) -> String in return "\(min)m"
            })
            
            seconds.insert("-", atIndex: 0)
            minutes.insert("-", atIndex: 0)
            self.trackRunTime.dataSource(minutes, arrayTwo: seconds, arrayThree: nil)
        }
    }
    
    @IBOutlet weak var genricEntryTextField: UITextField! {
        didSet {
            self.genricEntryTextField.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
