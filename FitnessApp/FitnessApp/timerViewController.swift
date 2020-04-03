//
//  timerViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/1/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit



class timerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerTextField: UITextField!
    
    let pickerList = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return 60
       }
       
    // This function sets the text of the picker view to row# + 1
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return String(row+1)
       }
    
       // When user selects an option, this function will set the text of the text field to reflect the selected option.
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           pickerTextField.text = String(row+1)
       }
    
        @objc func donePicker() {
           pickerTextField.resignFirstResponder()
       }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make icon on right of text field
        //let iconView = UIImageView(image: UIImage(named: "down_arrow"))
        //pickerTextField.rightView = iconView
        //pickerTextField.rightViewMode = .always

        // Make done button
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        pickerTextField.inputAccessoryView = toolBar

        //Make dropdownlist
        pickerTextField.inputView = pickerList
        
        //Connect Data
        self.pickerList.delegate = self
        self.pickerList.dataSource = self
    }
    
    
    
      
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
