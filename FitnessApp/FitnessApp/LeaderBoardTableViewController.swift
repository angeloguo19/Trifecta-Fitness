//
//  LeaderBoardTableViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/19/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class leaderBoardCell: UITableViewCell{
    
    @IBOutlet weak var lbMainView: UIView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class LeaderBoardTableViewController: UITableViewController {
    
    var nameText: String = ""
    var workoutList: workoutStruct = workoutStruct(workout: "", Data: [])
         
    var leaderBoardCall: leaderBoard = leaderBoard(message: LeaderboardMessage(Workouts: []))
    
    let topGradient = CGColor(srgbRed: 185/255.0, green: 239/255.0, blue: 213/255.0, alpha: 1)
    //let bottomGradient = CGColor(srgbRed: 253/255.0, green: 253/255.0, blue: 150/255.0, alpha: 1)
    let bottomGradient = CGColor(srgbRed: 243/255.0, green: 193/255.0, blue: 85/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //callLeaderboard()
        //print(nameText)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let gradientView = CAGradientLayer()
        gradientView.colors = [topGradient, bottomGradient]
        gradientView.frame = tableView.layer.bounds
        let backgroundView = UIView(frame: tableView.layer.bounds)
        backgroundView.layer.insertSublayer(gradientView, at: 0)
        tableView.backgroundView = backgroundView
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderBoardCell", for: indexPath) as! leaderBoardCell
        
        cell.lbMainView.layer.cornerRadius = cell.lbMainView.frame.height/4
        //cell.mainCellLayer.layer.borderWidth = 1
        //cell.mainCellLayer.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        cell.amountLabel.text = String(workoutList.Data[indexPath.row].amount)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.clear
        cell.lbMainView.layer.masksToBounds = true
        
        cell.lbMainView.backgroundColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)
        cell.nameLabel.text = String(indexPath.row+1) + ". " + workoutList.Data[indexPath.row].username
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
//        print(nameText)
//        for wkout in leaderBoardCall.message.Workouts{
//
//            if wkout.workout == nameText{
//                print(wkout.Data.count)
//
//                return(wkout.Data.count)
//            }
//        }
        
        print(workoutList.Data.count)
        //return 0
        return workoutList.Data.count
        
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.text = nameText
        header.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        //header.textLabel?.font = UIFont(name: "Georgia", size: 35)
        //view.textLabel?.textColor = UIColor.white
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 35)

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nameText
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
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
                
                for wkout in self.leaderBoardCall.message.Workouts{
                    if wkout.workout == self.nameText{
                        self.workoutList = wkout
                    }
                }
                
                       
                DispatchQueue.main.async {
                   //self.tableView.reloadData()
                //self.checkUsername()
                    self.tableView.reloadData()
                    
               }
               
            } catch {
               print("JSON Decode error")
            }
        }
        task.resume()
           
    }
    
    
    
    

}
