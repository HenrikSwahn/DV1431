//
//  PickerTextFieldCell.swift
//  Collector
//
//  Created by Henrik Swahn on 2015-12-17.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class PickerTextFieldCell: ColoredTableViewCell, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var pickerTextField: UIPickerTextField! {
        didSet {
            self.pickerTextField.delegate = self
        }
    }
    
    @IBOutlet weak var keyLabel: UILabel!
    
    override func updateUI() {
        if let media = model as? KeyValueAdapter {
            setContext(media.key)
            pickerTextField.text = media.value
            keyLabel.text = media.key
            
        }
    }
    
    override func updateUIColor() {
        self.contentView.backgroundColor = self.backgroundUIColor()
        self.pickerTextField.textColor = self.primaryUIColor()
    }
    
    private func setContext(context: String) {
        
        switch context {
        case "Format":
            setFormatDatasource()
        case "Runtime":
            setRuntimeDatasource()
        case "Type":
            setTypeDatasource()
        case "Release":
            setReleaseDatasource()
        default: break
        }
    }
    
    private func setFormatDatasource() {
        self.pickerTextField.dataSource(["DVD", "Blu-Ray", "MP4"], arrayTwo: nil, arrayThree: nil)
    }
    
    private func setRuntimeDatasource() {
        
        var seconds: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (second, _) -> String in return "\(second)s"
        })
        
        var minutes: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (min, _) -> String in return "\(min)m"
        })
        
        var hours: [String] = [Int](count: 60, repeatedValue: 0).mapNumber({
            (hour, _) -> String in return "\(hour)h"
        })
        
        seconds.insert("-", atIndex: 0)
        minutes.insert("-", atIndex: 0)
        hours.insert("-", atIndex: 0)
        self.pickerTextField.dataSource(hours, arrayTwo: minutes, arrayThree: seconds)
    }
    
    private func setTypeDatasource() {
        self.pickerTextField.dataSource(["Physical", "Digital"], arrayTwo: nil, arrayThree: nil)
    }
    
    private func setReleaseDatasource() {
        let years: [String] = [Int](count: 100, repeatedValue: 0).mapNumber({
            (year, _) -> String in return "\(2015 - year)"
        })
        
        self.pickerTextField.dataSource(years, arrayTwo: nil, arrayThree: nil)
    }
}

