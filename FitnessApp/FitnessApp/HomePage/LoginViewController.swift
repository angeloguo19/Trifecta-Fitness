//
//  LoginViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/11/20.
//  Copyright © 2020 Duke University. All rights reserved.
//
struct jsonCall: Codable{
    var message: Message?
    var err: String?
}
struct Message: Codable{
    var Stats: [StatsStruct]
    var Challenges: [ChallengesStruct]
}
struct StatsStruct: Codable{
    var workout: String
    var amount: Int
}
struct ChallengesStruct: Codable{
    var opponent: String
    var workout: String
    var amount: Int //should be int
    var you: Int //should be int
    var them: Int
    var completed: Bool
    //var first: String
}

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    var serverCall: jsonCall = jsonCall(message: Message(Stats: [], Challenges: []), err: nil)
    @IBOutlet weak var loginButton: UIButton!
    
    var username = ""
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginTapped(_ sender: Any) {
        //if(canTap) {
          //  canTap = !canTap
            createSpinnerView()
            if(usernameField.text == nil || usernameField.text!.isEmpty || hasWhiteSpace(str: usernameField.text!)){
                removeSpinnerView()
                let alertController = UIAlertController(title: "Incorrect Password or Username", message:
                    "Please enter your username or create a new account", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                dismissKeyboard()
                checkLogin()
            }
        //}
    }
    
    @IBAction func createTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "createAccSegue", sender: self)
    }
    
    class SpinnerViewController: UIViewController {
        var spinner = UIActivityIndicatorView(style: .large)
        
        override func viewDidLoad() {
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            view.addSubview(spinner)
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        }
    }
    
    func createSpinnerView() {
        spinner = SpinnerViewController()
        
        addChild(spinner!)
        spinner!.view.frame = view.frame
        view.addSubview(spinner!.view)
        spinner!.didMove(toParent: self)
    }
    
    func removeSpinnerView() {
        self.spinner!.willMove(toParent: nil)
        self.spinner!.view.removeFromSuperview()
        self.spinner!.removeFromParent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createAccSegue") {
        }
        else{
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?[0] as! UINavigationController
            let dest = nav.topViewController as! HomeTableViewController
            dest.mainCall = serverCall
            dest.hasData = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    let cellColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)
    let topGradient = CGColor(srgbRed: 106/255.0, green: 194/255.0, blue: 164/255, alpha: 1)
    let bottomGradient = CGColor(srgbRed: 192/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    
    var spinner: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
       // print(username)
        //getData()
        loginButton.layer.cornerRadius = loginButton.bounds.height/4
        loginButton.backgroundColor = cellColor
        usernameField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.layer.bounds
        gradientLayer.colors = [topGradient,bottomGradient]
        //gradientLayer.startPoint = CGPoint(x: 0,y: 0)
        //gradientLayer.endPoint = CGPoint(x: 1,y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        //[0].colors = [bottomRightGradient, bottomLeftGradient]
    }
        
    func storeData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Login", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        newEntity.setValue(usernameField.text, forKey: "username")

        do{
            try context.save()
            print("saved username")
        }catch{
            print("failed to save username")
        }
        
    }
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                username = data.value(forKey:"username") as! String
                print(username)
            }
        }
        catch{
            print("fails")
        }
    }
    
    func checkLogin() {
           // 2. BEGIN NETWORKING code
           //
                   let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "http://152.3.69.115:8081/api/stats/" + usernameField.text!)!

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
        removeSpinnerView()
        if(serverCall.err == nil){
            print("Valid Username")
            let defaults = UserDefaults.standard
            defaults.set(usernameField.text, forKey: "username")
            self.performSegue(withIdentifier: "loginSegue", sender: self)

        }
        else {
            print("Username doesn't exist")
            
            let alertController = UIAlertController(title: "Incorrect Password or Username", message:
                "Try entering your information again, or create a new account", preferredStyle: .alert)
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

    func dismissKeyboard() {
        usernameField.resignFirstResponder()
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

extension LoginViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }
}
