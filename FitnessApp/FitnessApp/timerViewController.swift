//
//  timerViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/1/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit



class timerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var progressTextField: UITextField!
    
    let timerList = UIPickerView()
    let progressList = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
    }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
       
    // This function sets the text of the picker view to row# + 1
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1) + " min"
    }
    
    // When user selects an option, this function will set the text of the text field to reflect the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timerTextField.text = String(row+1) + " min"
        //progressTextField.text = String(row+1) + " min"
    }
    
    @objc func donePicker() {
        timerTextField.resignFirstResponder()
        progressTextField.resignFirstResponder()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Make icon on right of text field
        let arrow = UIImageView(image: UIImage(named: "down_arrow"))
        arrow.contentMode = UIView.ContentMode.center
        arrow.frame = CGRect(x: 0.0, y: 0.0, width: 1, height: 1)
        pickerTextField.rightView = arrow
        pickerTextField.rightViewMode = UITextField.ViewMode.always
        */
        
        // Make done button
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        timerTextField.inputAccessoryView = toolBar
        progressTextField.inputAccessoryView = toolBar

        //Make dropdownlist
        timerTextField.inputView = timerList
        progressTextField.inputView = progressList
        
        //Connect Data
        timerList.delegate = self
        timerList.dataSource = self
        progressList.delegate = self
        progressList.dataSource = self
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
