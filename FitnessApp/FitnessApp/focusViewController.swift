//
//  focusViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/7/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class focusViewController: UIViewController {
    
    var nameText: String = ""
    var waitNum: Int = 0
    var servingsNum: Int = 0
    var id: Int = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var foodPicture: UIImageView!
    
    struct Information: Codable {
        var extendedIngredients: [Ingredients]
        var instructions: String
    }
    
    struct Ingredients: Codable {
        var amount: Double
        var unit: String
        var originalName: String
    }
    
    var totalInstructions: Information = Information(extendedIngredients: [], instructions: "")
        
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        
        
        nameLabel.text = nameText
        timeLabel.text = "Total Time: " + String(waitNum) + " mins"
        servingsLabel.text = "Servings: " + String(servingsNum)
    }
    
    func getData() {
        
        // 2. BEGIN NETWORKING code
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        //hard code 25 results at end
        let link: String = "https://api.spoonacular.com/recipes/" + String(id) + "/information?includeNutrition=false&apiKey=611d546c1bc54cf8baa25037850009d7"
        let url = URL(string: link)!

        // 3. MAKE THE HTTPS REQUEST task
        
        let alert1 = UIAlertController(title: "No Internet Connection", message: "iPhone must be connected to internet for app to run", preferredStyle: .alert)
        
        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let task = mySession.dataTask(with: url) { data, response, error in

            // ensure there is no error for this HTTP response
            guard error == nil else {
                DispatchQueue.main.async {
                    self.present(alert1, animated: true)
                }
                return
            }
            // ensure there is data returned from this HTTP response
            guard let jsonData = data else {
                print("No data")
                return
            }
            print("Got the data from network")
        
        // 4. DECODE THE RESULTING JSON
        //
            let decoder = JSONDecoder()
            //print(String(data: jsonData, encoding: .utf8))

            do {
                // decode the JSON into our array of todoItem's
                self.totalInstructions = try decoder.decode(Information.self, from: jsonData)
                                
                //DispatchQueue.main.async {
                //    self.tableView.reloadData()
                //}
            } catch {
                print("JSON Decode error")
            }
        }
     
        // actually make the http task run.
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
