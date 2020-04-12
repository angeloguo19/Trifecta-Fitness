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
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionSizes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionSizes[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        if(indexPath.section == 0){
            cell.leftLabel.text = challengeList[indexPath.row]
            cell.rightLabel.text = ""
        }
        else{
            cell.leftLabel.text = workouts[indexPath.row]
            cell.rightLabel.text = stats[indexPath.row]
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
