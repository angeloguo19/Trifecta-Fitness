//
//  addScreenViewController.swift
//  FitnessApp
//
//  Created by Amr Bedawi on 4/18/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class addScreenViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var workoutField: UITextField!
    @IBOutlet weak var repsField: UITextField!

    var username: String = ""
    var workout: String = ""
    var reps: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


    }

    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func saveTap(_ sender: Any) {

        //save by calling challenge and using inputed info
        username = userField.text!
        workout = workoutField.text!
        reps = Int(repsField.text!)!
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

}
