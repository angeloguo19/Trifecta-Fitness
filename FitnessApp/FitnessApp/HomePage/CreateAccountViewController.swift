//
//  CreateAccountViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/14/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var createAccount: UIButton!
    @IBAction func createButton(_ sender: Any) {
        // Call oliver api and see if username can be created
        //If so, set username and then dismiss
        //dismiss(animated: true, completion: nil)
        
        if(usernameField.text == nil || usernameField.text!.isEmpty || hasWhiteSpace(str: usernameField.text!)){
            let alertController = UIAlertController(title: "Invalid Username", message:
                "Please do not use spaces in username", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)

        }
        else{
            checkLogin()
        }
        
    }
    
    struct jsonCall: Codable{
        var message: String
        var err: String?
    }
    
    var serverCall: jsonCall = jsonCall(message: "",err:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        // UI for ViewController
        let topGradient = CGColor(srgbRed: 106/255.0, green: 194/255.0, blue: 164/255, alpha: 1)
        let bottomGradient = CGColor(srgbRed: 192/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.layer.bounds
        gradientLayer.colors = [topGradient,bottomGradient]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    //http://152.3.69.115:8081/api/new/username
    
    func checkLogin() {
           
           // 2. BEGIN NETWORKING code
           //
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "http://152.3.69.115:8081/api/new/" + usernameField.text!)!

           // 3. MAKE THE HTTPS REQUEST task
           //
        let task = mySession.dataTask(with: url) { data, response, error in

                       // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                               
                DispatchQueue.main.async {
                    let alert1 = UIAlertController(title: "Error", message: "Issues connecting with internet", preferredStyle: .alert) //.actionSheet
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
                       
                       //print("Got the data from network")
           // 4. DECODE THE RESULTING JSON
           //
           let decoder = JSONDecoder()
           //print(String(data: jsonData, encoding: .utf8))
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
        }

               // actually make the http task run.
        task.resume()
           
    }
    func checkUsername(){
        if(serverCall.err == nil){
            let alertController = UIAlertController(title: "Successfully created an account!", message:
                "Please login with your details", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            //dismiss(animated: true, completion: nil)
        }
        else if(serverCall.err == "User Already Exists"){
            let alertController = UIAlertController(title: "Username already exists", message:
                "Please choose a new username", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    func hasWhiteSpace(str:String) -> Bool{
        
       let character: Character = " "
       if str.contains(" ") {
           return true
       } else {
           return false
       }
    }
    

}
