//
//  UIPickerTextField.swift
//  Collector
//
//  Created by Dino Opijac on 19/11/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class UIPickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    // MARK: - Instance variables
    private var picker: UIPickerView!
    private var dataOne: [String]?
    private var dataTwo: [String]?
    private var dataThree: [String]?
    internal var componentState = ComponentState.OneComponents
    
    private enum Default {
        static let componentOne: Int = 0
        static let componentTwo: Int = 1
        static let componentThree: Int = 2
    }
    
    internal enum ComponentState {
        case OneComponents
        case TwoComponents
        case ThreeComponents
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.picker = UIPickerView()
        self.inputView = self.picker
        self.enabled = false
        
        self.delegate = self
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    /**
     Use this method to set the source of the data. This method should preferably be
     used in viewDidLoad
     
     - Parameter source: The source array to set as string
     */
    func dataSource(arrayOne: [String], arrayTwo: [String]?, arrayThree: [String]?) {
        self.dataOne = arrayOne
        componentState = .OneComponents
        
        if (arrayTwo != nil) {
            self.dataTwo = arrayTwo
            componentState = .TwoComponents
        }
        
        if (arrayThree != nil) {
            self.dataThree = arrayThree
            componentState = .ThreeComponents
        }
        
        self.enabled = true
        self.text = selectedRow()
    }
    
    // MARK: - Private methods
    private func selectedRow() -> String? {
        
        switch componentState {
        case .OneComponents:
            return dataOne?[self.picker.selectedRowInComponent(Default.componentOne)];
        case .TwoComponents:
            return (dataOne?[self.picker.selectedRowInComponent(Default.componentOne)])! + " \(dataTwo![self.picker.selectedRowInComponent(Default.componentTwo)])"
        case .ThreeComponents:
            return (dataOne?[self.picker.selectedRowInComponent(Default.componentOne)])! + " \(dataTwo![self.picker.selectedRowInComponent(Default.componentTwo)])" + " \(dataThree![self.picker.selectedRowInComponent(Default.componentThree)])"
            
        }
    }
    
    private func pick(item: String?) -> Bool {
        if let index = dataOne?.indexOf(item!) {
            self.picker.selectRow(index, inComponent: Default.componentOne, animated: false)
            return true
        }
        
        return false
    }
    
    // MARK: - UIPickerView Delegation
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        if (dataTwo == nil) && (dataThree == nil) {
            return 1
        }
        else if (dataTwo != nil) && (dataThree == nil) {
            return 2
        }
        else if (dataTwo != nil) && (dataThree != nil) {
            return 3
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if componentState == .OneComponents {
            self.endEditing(true)
        }
        else if componentState == .TwoComponents {
            if pickerView.selectedRowInComponent(0) > 0 && pickerView.selectedRowInComponent(1) > 0 {
                self.endEditing(true)
            }
        }
        else {
            if pickerView.selectedRowInComponent(0) > 0 && pickerView.selectedRowInComponent(1) > 0 && pickerView.selectedRowInComponent(2) > 0 {
                self.endEditing(true)
            }
        }
        self.text = selectedRow()
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return dataOne?[row]
        case 1:
            return dataTwo?[row]
        case 2:
            return dataThree?[row]
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        switch component {
        case 0:
            if let count = dataOne?.count {
                return count
            }
        case 1:
            if let count = dataTwo?.count {
                return count
            }
        case 2:
            if let count = dataThree?.count {
                return count
            }
        default:
            return 0
        }
        
        return 0
    }
    
    
    // MARK: - UITextField Delegation
    func textFieldDidBeginEditing(textField: UITextField) {
        self.text = self.selectedRow()
        self.picker.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if componentState == .OneComponents {
            self.picker.hidden = true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self && componentState == .OneComponents) {
            //textField.resignFirstResponder()
            
            let selected = selectedRow()
            
            // Lookups take a long time, need to be dispatched
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
                let didChange = self.pick(textField.text)
            
                if !didChange {
                    self.text = selected
                }
            })
            
            return false
        }
        
        return true
    }
}
