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
    
    var nameText: String = ""
    
    var username = ""
    
    struct jsonCall: Codable{
        var message: String
        var err: String?
    }
    
    var serverCall: jsonCall = jsonCall(message: "",err:"")
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
