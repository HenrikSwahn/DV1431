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
    private var data: [String]?
    
    private enum Default {
        static let component: Int = 0
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
    func dataSource(array: [String]) {
        self.data = array
        self.enabled = true
        self.text = selectedRow()
    }
    
    // MARK: - Private methods
    private func selectedRow() -> String? {
        return data?[self.picker.selectedRowInComponent(Default.component)]
    }
    
    private func pick(item: String?) -> Bool {
        if let index = data?.indexOf(item!) {
            self.picker.selectRow(index, inComponent: Default.component, animated: false)
            return true
        }
        
        return false
    }
    
    // MARK: - UIPickerView Delegation
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.endEditing(true)
        self.text = selectedRow()
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data?[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let count = data?.count {
            return count
        }
        
        return 0
    }
    
    
    // MARK: - UITextField Delegation
    func textFieldDidBeginEditing(textField: UITextField) {
        self.text = self.selectedRow()
        self.picker.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.picker.hidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self) {
            textField.resignFirstResponder()
            
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
