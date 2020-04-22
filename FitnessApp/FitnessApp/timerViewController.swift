//
//  timerViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/1/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class timerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    // MARK: - Notification Code
    func permission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                    //print("All set!")
            }
        }
    }
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Time's Up!"
        content.body = "Timer has finished"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    // MARK: Init Vars/Button funcs
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerTextField: UITextField!
    
    @IBOutlet weak var progressTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
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
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if Int(progressTextField.text!) != nil {
            let addedTime: Int = Int(progressTextField.text!)!
            
            let calendar = Calendar(identifier: .gregorian)
            let units: Set<Calendar.Component> = [.year, .month, .day]
            let components = calendar.dateComponents(units, from: Date())
            let date: NSDate = calendar.date(from: components)! as NSDate
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            var changed = 0
            
            // Retrieve data to see if there's etity for today and update if present
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                for result in results as! [NSManagedObject] {
                    let tempdate: NSDate = result.value(forKey: "date") as! NSDate
                    let temptime = result.value(forKey: "time") as! Int
                    if tempdate == date {
                        result.setValue(temptime + addedTime, forKey: "time")
                        do {
                            try context.save()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        changed = 1
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            // Make new entity for today's date
            if changed == 0 {
                let entity = NSEntityDescription.entity(forEntityName: "Session", in: context)!
                let newSession = NSManagedObject(entity: entity, insertInto: context)
                newSession.setValue(date, forKey: "date")
                newSession.setValue(addedTime, forKey: "time")
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
        } else{
            let alert = UIAlertController(title: "Integer was not Entered", message: "You must enter an integer to update your progress", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
    
    // MARK: Timer Setup
    let timerList = UIPickerView()
    var timer = Timer()
    var startTime: Int = 0
    var totalTime: Int = 0
    var isTimerRunning = false
    var resumeTapped = false

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    @objc func updateTimer() {
        if totalTime == 0 {
            timer.invalidate()
            isTimerRunning = false
            scheduleNotification()
            
            let timerAlert = UIAlertController(title: "Time's Up", message: "Would you like to automatically update your meditation time by " + String(startTime/60) + " mins?", preferredStyle: .alert)
            timerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            timerAlert.addAction(UIAlertAction(title: "Yes", style: .default ,handler: {
                action in
                self.progressTextField.text = String(self.startTime/60)
                self.updateButtonTapped(self.updateButton)
            }))
            self.present(timerAlert, animated: true)
            
            resetButtonTapped(resetButton)
             
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
    
    
    // MARK: Pickerview Setup
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
    }
    @objc func donePicker() {
        timerTextField.resignFirstResponder()
        progressTextField.resignFirstResponder()
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        progressTextField.resignFirstResponder()
    }
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
                
        permission()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
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
        
        //Connect Data
        timerList.delegate = self
        timerList.dataSource = self
        
        let buttColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)
        // Change appearance of the buttons
        startButton.layer.shadowOpacity = 0.5
        startButton.layer.shadowRadius = 1
        startButton.layer.cornerRadius = 35
        startButton.layer.borderWidth = 0
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        startButton.layer.masksToBounds = false
        startButton.layer.backgroundColor = buttColor.cgColor
        
        pauseButton.layer.shadowOpacity = 0.5
        pauseButton.layer.shadowRadius = 1
        pauseButton.layer.cornerRadius = 35
        pauseButton.layer.borderWidth = 0
        pauseButton.layer.borderColor = UIColor.black.cgColor
        pauseButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        pauseButton.layer.masksToBounds = false
        pauseButton.isEnabled = false
        pauseButton.layer.backgroundColor = buttColor.cgColor
        
        resetButton.layer.shadowOpacity = 0.5
        resetButton.layer.shadowRadius = 1
        resetButton.layer.cornerRadius = 35
        resetButton.layer.borderWidth = 0
        resetButton.layer.borderColor = UIColor.black.cgColor
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        resetButton.layer.masksToBounds = false
        resetButton.layer.backgroundColor = buttColor.cgColor
        
        updateButton.layer.cornerRadius = 6
        updateButton.layer.borderWidth = 0
        updateButton.layer.borderColor = UIColor.black.cgColor
        updateButton.layer.backgroundColor = buttColor.cgColor
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let topGradient = CGColor(srgbRed: 255/255.0, green: 159.0/255.0, blue: 231.0/255.0, alpha: 1)
        let bottomGradient = CGColor(srgbRed: 255/255.0, green: 179/255.0, blue: 71/255.0, alpha: 1)
        let gradientView = CAGradientLayer()
        gradientView.frame = view.layer.bounds
        gradientView.colors = [topGradient, bottomGradient].reversed()
        view.layer.insertSublayer(gradientView, at: 0)
    
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
