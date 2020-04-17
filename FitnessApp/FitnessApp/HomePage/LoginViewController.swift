//
//  LoginViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/11/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    struct jsonCall: Codable{
        var err: String
    }
    
    var serverCall: jsonCall = jsonCall(err:"")
    
    var username = ""

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(usernameField.text, forKey: "username")
        checkLogin()
        self.performSegue(withIdentifier: "loginSegue", sender: self)

    }
    @IBAction func createTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "createAccSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("hi")
        
        let defaults = UserDefaults.standard
        let tempUsername = defaults.string(forKey: "username")
        if(tempUsername != nil){
            print(tempUsername)
             
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            print("wtf")
        }
        else{
         //print("yo")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
       // print(username)
        //getData()
        usernameField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
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
        if(serverCall.err == "An error occured"){
            print("Username doesn't exist")
        }
        else{
            print("yessir")
        }
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
