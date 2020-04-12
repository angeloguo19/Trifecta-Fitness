//
//  HomeTableViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/11/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    //@IBOutlet weak var taskLabel: UILabel!
   // @IBOutlet weak var completeYN: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class HomeTableViewController: UITableViewController {
    @IBAction func loginTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "username")
        dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "loginSegue", sender: self)

    }
    var challengeList=["Sergio", "Obama", "Bobert"]
    var stats = ["100","50","30","200","5"]
    var workouts = ["Push Ups","Sit Ups","Pull Ups","Squats","Miles"]
    var sectionTitles = ["Challenges", "Workouts"]
    var sectionSizes = [3,5]
    
    var username = ""
    
    var debugging = false
    
    struct jsonCall: Codable{
        var message: Message
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
    //var mainCall: jsonCall

    var mainCall: jsonCall = jsonCall(message: Message(Stats:[],Challenges:[]))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()
        print("hi")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func getAllData() {
        
        // 2. BEGIN NETWORKING code
        //
                let mySession = URLSession(configuration: URLSessionConfiguration.default)

                let url = URL(string: "http://152.3.69.115:8081/api/stats/low10")!

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
                    
                    print("Got the data from network")
        // 4. DECODE THE RESULTING JSON
        //
                    let decoder = JSONDecoder()
                    print(String(data: jsonData, encoding: .utf8))
                    do {
                        // decode the JSON into our array of todoItem's
                        self.mainCall = try decoder.decode(jsonCall.self, from: jsonData)
                                
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch {
                        print("JSON Decode error")
                    }
                }

            // actually make the http task run.
            task.resume()
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if debugging{
            return sectionSizes.count
        }
        else{
            return 2 //Challenges + workout
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if debugging{
                 return sectionSizes[section]
        }
        if section == 0{
            return mainCall.message.Challenges.count
        }
        else if section == 1{
            return mainCall.message.Stats.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        if debugging{
            if(indexPath.section == 0){
                cell.leftLabel.text = challengeList[indexPath.row]
                cell.rightLabel.text = ""
            }
            else{
                cell.leftLabel.text = workouts[indexPath.row]
                cell.rightLabel.text = stats[indexPath.row]
            }
        }
        
        else{
            if(indexPath.section == 0){
                cell.leftLabel.text = mainCall.message.Challenges[indexPath.row].opponent
                cell.rightLabel.text = ""
            }
            else{
                cell.leftLabel.text = mainCall.message.Stats[indexPath.row].workout
                cell.rightLabel.text = String(mainCall.message.Stats[indexPath.row].amount)
            }
        }




        
        
      // Configure the cell...
      //cell.places?.text = places[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="loginSegue"){
            let destVC = segue.destination as! LoginViewController
            
        }
        else{
            let myRow = tableView!.indexPathForSelectedRow
            let myCurrentCell = tableView!.cellForRow(at: myRow!) as! HomeTableViewCell
            
            if(myRow?.section==0){
                let destVC = segue.destination as! ChallengesViewController
                print("one")
            }
            else{
                let destVC = segue.destination as! StatsViewController
                print("two")
            }
            
        }
        
        
        //destVC.place = (myCurrentCell.places?.text)!
        //destVC.weatherPic = (myCurrentCell.weatherIcon?.image)!
        //destVC.temp = (myCurrentCell.temperature?.text)!
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var segue: String!
        if indexPath.section == 0 {
            segue = "segue1"
        } else  {
            segue = "segue2"
        }
    
        
        self.performSegue(withIdentifier: segue, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("hi")
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
    

}
