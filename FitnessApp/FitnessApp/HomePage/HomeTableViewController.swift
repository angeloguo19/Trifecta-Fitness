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
    //@IBOutlet weak var taskLabel: UILabel!
   // @IBOutlet weak var completeYN: UISwitch!
//    @IBOutlet weak var amountLabel: UILabel!
//    @IBOutlet weak var workoutLabel: UILabel!
//    @IBOutlet weak var opProgressView: UIProgressView!
//    @IBOutlet weak var progressView: UIProgressView!
//    @IBOutlet weak var challengeLabel: UILabel!
//    @IBOutlet weak var mainCellLayer: UIView!
    
    @IBOutlet weak var opProgressView: UIProgressView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var mainCellLayer: UIView!
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
    
    let tabBarColor = UIColor(red: 128.0/255, green: 226.0/255, blue: 255/255, alpha: 0.9)
    let cellGradient = false
    let topCellColor = CGColor(srgbRed: 150/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    let bottomCellColor = CGColor(srgbRed: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    let cellColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    let topGradient = CGColor(srgbRed: 186.0/255, green: 159.0/255, blue: 231.0/255, alpha: 1)
    let bottomGradient = CGColor(srgbRed: 128.0/255, green: 250.0/255, blue: 255/255, alpha: 1)
    let cellLightColor = CGColor(srgbRed: 186.0/255, green: 200.0/255, blue: 231.0/255, alpha: 1)

    var mainCall: jsonCall = jsonCall(message: Message(Stats:[],Challenges:[]))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = backgroundColor
        getAllData()
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 156.0/255, green: 236.0/255, blue: 255.0/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.tabBarController?.tabBar.backgroundColor = UIColor.clear
        self.tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundImage = UIImage()
        
        let amount = 125
        var tabFrame = tabBarController?.tabBar.frame
        tabFrame?.size.height = CGFloat(amount)
        tabFrame?.origin.y = self.view.frame.size.height - CGFloat(amount)
        tabBarController?.tabBar.frame = tabFrame!
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = (tabBarController?.tabBar.bounds)!
        tabBarController?.tabBar.insertSubview(blurView, at: 0)
        //tabBarController?.tabBar.isTranslucent = true
        
        self.tabBarController?.tabBar.layer.borderWidth = 0
        self.tabBarController?.tabBar.clipsToBounds = true
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = tableView.bounds
        gradientLayer.colors = [topGradient, bottomGradient]
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
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
                    //print(String(bytes: jsonData, encoding:  .utf8))
                    let decoder = JSONDecoder()
                    //print(String(data: jsonData, encoding: .utf8))
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainCall.message.Challenges.count
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if debugging{
            return sectionSizes.count
        }
        else{
            return 1 //Challenges + workout
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
    
        cell.mainCellLayer.layer.cornerRadius = cell.mainCellLayer.frame.height/4
        //cell.mainCellLayer.layer.borderWidth = 1
        //cell.mainCellLayer.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.clear
        cell.mainCellLayer.layer.masksToBounds = true
        if cellGradient {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = cell.mainCellLayer.bounds
            gradientLayer.colors = [topCellColor, bottomCellColor]
            cell.mainCellLayer.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            cell.mainCellLayer.backgroundColor = cellColor
        }
        cell.progressView.progress = Float(mainCall.message.Challenges[indexPath.row].you) / Float(mainCall.message.Challenges[indexPath.row].amount)
        cell.opProgressView.progress = Float(mainCall.message.Challenges[indexPath.row].them) / Float(mainCall.message.Challenges[indexPath.row].amount)
        let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        cell.progressView.transform = transform
        cell.opProgressView.transform = transform
        print("Checking for data from \(mainCall)")
        cell.challengeLabel.text = mainCall.message.Challenges[indexPath.row].opponent
        cell.amountLabel.text = String( mainCall.message.Challenges[indexPath.row].amount)
        cell.workoutLabel.text = mainCall.message.Challenges[indexPath.row].workout
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        header.textLabel?.font = header.textLabel?.font.withSize(35)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
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
