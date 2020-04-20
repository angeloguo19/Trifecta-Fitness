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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //color the background
       let topGradient = CGColor(srgbRed: 255/255.0, green: 159.0/255.0, blue: 231.0/255.0, alpha: 1)
       let bottomGradient = CGColor(srgbRed: 255/255.0, green: 179/255.0, blue: 71/255.0, alpha: 1)
       let gradientView = CAGradientLayer()
       gradientView.frame = view.layer.bounds
       gradientView.colors = [topGradient, bottomGradient].reversed()
       view.layer.insertSublayer(gradientView, at: 0)
    //color the nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    //set up pickers
        workoutPickerData = ["Push Ups","Sit Ups","Pull ups", "Squats","Burpees","Lunges","Bicep Curls","Calf Raises", "Bicycle Kicks"]
        workoutPicker.delegate = self
        workoutPicker.dataSource = self
        
    //make dropdown
        workoutField.inputView = workoutPicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        workoutField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
       view.endEditing(true)
    }


    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func saveTap(_ sender: Any) {

        //save by calling challenge and using inputed info
//        username = userField.text!
//        workout = workoutField.text!
//        reps = Int(repsField.text!)!
        createChallenge()
        self.dismiss(animated: true, completion: nil)
        //throw error if fields are empty
    }

    func createChallenge() {

           // 2. BEGIN NETWORKING code
           //
        let mySession = URLSession(configuration: URLSessionConfiguration.default)

        let url = URL(string: "http://152.3.69.115:8081/api/challenge/low10" + "/" + userField.text! + "/" + workoutField.text! + "/" + repsField.text!)!

           // 3. MAKE THE HTTPS REQUEST task
           //
        let task = mySession.dataTask(with: url) { data, response, error in

                       // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")

                DispatchQueue.main.async {
                    let alert1 = UIAlertController(title: "Error", message: "Issues connecting with internet", preferredStyle: .alert)

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

          // let decoder = JSONDecoder()


            /*
           do {
               // decode the JSON into our array of todoItem's
               self.serverCall = try decoder.decode(jsonCall.self, from: jsonData)

               DispatchQueue.main.async {
                   //self.tableView.reloadData()
                self.checkUsername()
               }

           } catch {
               print("JSON Decode error")
           }
            */
        }

        task.resume()

    }

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
