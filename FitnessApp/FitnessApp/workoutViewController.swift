//
//  workoutViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/5/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class workoutViewController: UIViewController {
    
    @IBOutlet weak var currentLeaderView: UIView!
    @IBOutlet weak var leaderLabel: UILabel!
    

    @IBOutlet weak var currentReps: UILabel!
    
    
    var nameText: String = ""
    
    var username = ""
    
    struct jsonCall: Codable{
        var message: String
        var err: String?
    }
    
    struct leaderBoard: Codable{
        var message: Message
    }
    struct Message: Codable{
        var Workouts: [workoutStruct]
    }
    struct workoutStruct: Codable{
        var workout: String
        var Data: [people]
    }
    struct people: Codable{
        var username: String
        var amount: Int
    }
   
    
    var serverCall: jsonCall = jsonCall(message: "",err:"")
    var leaderBoardCall: leaderBoard = leaderBoard(message: Message(Workouts: []))
    //var mainCall: jsonCall = jsonCall(message: Message(Stats:[],Challenges:[]))
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet weak var reps: UITextField!
    
    @IBOutlet weak var tutorialVid: WKWebView!
    let defaults = UserDefaults.standard
    
    @IBAction func updateStat(_ sender: UIButton) {
        let rep = (reps.text! as NSString).integerValue
        let workout = nameText
        var current = defaults.integer(forKey: workout)
        current = current + rep
        defaults.set(current, forKey: workout)
        defaults.synchronize()
        
        username = defaults.string(forKey: "username")!
        print(username)
        
        
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "http://152.3.69.115:8081/api/update/" + username + "/" + nameText + "/" + reps.text!)!

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
               }
               
           } catch {
               print("JSON Decode error")
           }
        }

               // actually make the http task run.
        task.resume()
    }
    
    @objc func donePicker() {
        reps.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       // Make done button
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
       toolBar.setItems([doneButton], animated: true)
       toolBar.isUserInteractionEnabled = true
       reps.inputAccessoryView = toolBar

        
        workoutNameLabel.text = nameText

        workoutNameLabel.layer.borderColor = UIColor.black.cgColor
        workoutNameLabel.layer.borderWidth = 1
        let videoKey = nameText + "Video"
        let video = defaults.string(forKey: videoKey)!
        let link = "https://www.youtube.com/embed/" + video
        let myURL = URL(string: link)
        let youtubeRequest = URLRequest(url: myURL!)
        tutorialVid.load(youtubeRequest)
        
        // UI for ViewController
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let topGradient = CGColor(srgbRed: 185/255.0, green: 239/255.0, blue: 213/255.0, alpha: 1)
           //let bottomGradient = CGColor(srgbRed: 253/255.0, green: 253/255.0, blue: 150/255.0, alpha: 1)
           let bottomGradient = CGColor(srgbRed: 255/255.0, green: 179/255.0, blue: 71/255.0, alpha: 1)
        //let topGradient = CGColor(srgbRed: 255/255.0, green: 190/255.0, blue: 175/255.0, alpha: 1)
        //let bottomGradient = CGColor(srgbRed: 139/255.0, green: 207/255.0, blue: 250/255.0, alpha: 1)
        let gradientView = CAGradientLayer()
        gradientView.frame = view.layer.bounds
        gradientView.colors = [topGradient, bottomGradient]
        view.layer.insertSublayer(gradientView, at: 0)
        
        workoutNameLabel.layer.borderWidth = 0
        
        
        currentLeaderView.layer.cornerRadius = currentLeaderView.frame.height/4
        
        currentLeaderView.backgroundColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)
        currentLeaderView.layer.masksToBounds = true
        
        callLeaderboard()
    }
    
    func callLeaderboard() {
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: "http://152.3.69.115:8081/api/leaderboard")!


        let task = mySession.dataTask(with: url) { data, response, error in

                       
            guard error == nil else {
                print ("error: \(error!)")
                           
                DispatchQueue.main.async {
                    let alert1 = UIAlertController(title: "Error", message: "Issues connecting with internet", preferredStyle: .alert) //.actionSheet
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert1, animated: true)
                }
                return
            }
            guard let jsonData = data else {
                print("No data")
                return
            }
                       
      
            let decoder = JSONDecoder()
            do {
                self.leaderBoardCall = try decoder.decode(leaderBoard.self, from: jsonData)
                
                       
                DispatchQueue.main.async {
                   //self.tableView.reloadData()
                //self.checkUsername()
                    self.updateLeader()
               }
               
            } catch {
               print("JSON Decode error")
            }
        }
        task.resume()
           
    }
    
    func updateLeader(){
        
        for wkout in leaderBoardCall.message.Workouts{
            if wkout.workout == nameText{
                leaderLabel.text = "Current Leader: " + wkout.Data[0].username

                print(wkout.Data[0].username)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! LeaderBoardTableViewController
        destVC.nameText = self.nameText
        
    
    
    }

}
