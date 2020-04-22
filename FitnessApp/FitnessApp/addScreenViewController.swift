//
//  addScreenViewController.swift
//  FitnessApp
//
//  Created by Amr Bedawi on 4/18/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class addScreenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var workoutField: UITextField!
    @IBOutlet weak var repsField: UITextField!
    
    let workoutPicker = UIPickerView()
    
    var workoutPickerData: [String] = [String]()
    var selectedWorkout: String?
    var serverCall: jsonCall = jsonCall(message: "",err:"")
    var username = UserDefaults.standard.string(forKey: "username")!
    
    struct jsonCall: Codable {
        var message: String
        var err: String
    }
    
    @objc func donePicker() {
        repsField.resignFirstResponder()
        workoutField.resignFirstResponder()
        userField.resignFirstResponder()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        repsField.resignFirstResponder()
        userField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // Make done button
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        repsField.inputAccessoryView = toolBar
        workoutField.inputAccessoryView = toolBar
        userField.inputAccessoryView = toolBar
        
    //color the background
       let cellColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)
       let topGradient = CGColor(srgbRed: 186.0/255, green: 159.0/255, blue: 231.0/255, alpha: 1)
       let bottomGradient = CGColor(srgbRed: 128.0/255, green: 250.0/255, blue: 255/255, alpha: 1)
       let gradientView = CAGradientLayer()
       gradientView.frame = view.layer.bounds
       gradientView.colors = [topGradient, bottomGradient]
       view.layer.insertSublayer(gradientView, at: 0)
    //color the nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    //set up pickers
        workoutPickerData = ["Bicep Curls","Bicycle Kicks","Burpees","Calf Raises","Lunges","Push Ups","Pull ups","Sit Ups", "Squats"]
        workoutPicker.delegate = self
        workoutPicker.dataSource = self
        
    //make dropdown
        workoutField.inputView = workoutPicker
        
    
    }
    
    
    @objc func action() {
       view.endEditing(true)
    }


    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func saveTap(_ sender: Any) {

        //save by calling challenge and using inputed info but first check the inputs are good to go
        if (userField.text!.isEmpty || workoutField.text!.isEmpty || repsField.text!.isEmpty) {
            let emptyAlert = UIAlertController(title: "Missing Data", message: "Please fill out all three sections before creating a new challenge.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(emptyAlert, animated: true)
            print("entered if statement")
        }
        else{
        createChallenge()
        }
        //throw error if fields are empty
    }

    func createChallenge() {

           // 2. BEGIN NETWORKING code
           //
        let mySession = URLSession(configuration: URLSessionConfiguration.default)

        let url = URL(string: "http://152.3.69.115:8081/api/challenge/" + username + "/" + userField.text! + "/" + workoutField.text!.replacingOccurrences(of: " ", with: "%20") + "/" + repsField.text!)!

           // 3. MAKE THE HTTPS REQUEST task
           //
        let task = mySession.dataTask(with: url) { data, response, error in

                       // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")

                DispatchQueue.main.async {
                    let alert1 = UIAlertController(title: "No Internet Connection", message: "Connect to internet and restart app", preferredStyle: .alert)

                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert1, animated: true)
                }
                return
            }

                       // ensure there is data returned from this HTTP response
            guard let jsonData = data else {
                print("No data")
                return
            }

            print("Got network Data")
           // 4. DECODE THE RESULTING JSON

          let decoder = JSONDecoder()


            
           do {
               // decode the JSON into our array of todoItem's
               self.serverCall = try decoder.decode(jsonCall.self, from: jsonData)

               DispatchQueue.main.async {
                   //self.tableView.reloadData()
                self.checkValidUser()
               }

           } catch {
               print("JSON Decode error")
           }
            
        }

        task.resume()
    }
    
    func checkValidUser(){
        if(serverCall.err == "An error occured"){
            let alertController = UIAlertController(title: "User Not Found", message:
                "This user does not exist, please input a valid user name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            self.dismiss(animated: true, completion: {
                self.parentController!.getAllData(animated: false)
            })
        }
    }

    var parentController: challengesTableViewController?
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workoutPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workoutPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWorkout = workoutPickerData[row]
        workoutField.text = selectedWorkout
    }

}
