//
//  timerViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/1/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit



class timerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var progressTextField: UITextField!
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            startButton.isEnabled = false
        }
    }
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if resumeTapped == false {
            timer.invalidate()
            resumeTapped = true
            pauseButton.setTitle("Resume", for: UIControl.State.normal)
        }
        else if resumeTapped == true{
            runTimer()
            resumeTapped = false
            pauseButton.setTitle("Pause", for: UIControl.State.normal)
        }
    }
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        totalTime = startTime
        timerLabel.text = timeFormat(time: TimeInterval(totalTime))
        isTimerRunning = false
        resumeTapped = false
        pauseButton.isEnabled = false
        pauseButton.setTitle("Pause", for: UIControl.State.normal)
        startButton.isEnabled = true
    }
    
    
    let timerList = UIPickerView()
    let progressList = UIPickerView()
    
    var timer = Timer()
    var startTime: Int = 0
    var totalTime: Int = 0
    var isTimerRunning = false
    var resumeTapped = false

    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    @objc func updateTimer() {
        if totalTime < 1 {
            timer.invalidate()
            isTimerRunning = false
            //Send alert to indicate "time's up!"
        } else {
            totalTime -= 1     //This will decrement(count down)the seconds.
            timerLabel.text = timeFormat(time: TimeInterval(totalTime))
        }
    }
    func timeFormat(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
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
        totalTime = (row + 1) * 60
        startTime = (row + 1) * 60
        timerLabel.text = timeFormat(time: TimeInterval(totalTime))
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
        
        // Change appearance of the buttons
        startButton.layer.shadowOpacity = 0.5
        startButton.layer.shadowRadius = 1
        startButton.layer.cornerRadius = 35
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        startButton.layer.masksToBounds = false
        
        pauseButton.layer.shadowOpacity = 0.5
        pauseButton.layer.shadowRadius = 1
        pauseButton.layer.cornerRadius = 35
        pauseButton.layer.borderWidth = 1
        pauseButton.layer.borderColor = UIColor.black.cgColor
        pauseButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        pauseButton.layer.masksToBounds = false
        
        resetButton.layer.shadowOpacity = 0.5
        resetButton.layer.shadowRadius = 1
        resetButton.layer.cornerRadius = 35
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.black.cgColor
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        resetButton.layer.masksToBounds = false
        
        pauseButton.isEnabled = false
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