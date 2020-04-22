//
//  challengesTableViewController.swift
//  FitnessApp
//
//  Created by Amr Bedawi on 4/17/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData

class challengesTableViewCell: UITableViewCell {
    @IBOutlet weak var mainCellLayer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var yourProgress: UIProgressView!
    @IBOutlet weak var theirProgress: UIProgressView!
    @IBOutlet weak var youAmount: UILabel!
    @IBOutlet weak var themAmount: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization Code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //Configure view for selected state
    }
}

class challengesTableViewController: UITableViewController {
    
    
    // MARK: - Response
    
    let cellGradient = false
    let topCellColor = CGColor(srgbRed: 150/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    let bottomCellColor = CGColor(srgbRed: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    let cellColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)
    let topGradient = CGColor(srgbRed: 186.0/255, green: 159.0/255, blue: 231.0/255, alpha: 1)
    let bottomGradient = CGColor(srgbRed: 128.0/255, green: 250.0/255, blue: 255/255, alpha: 1)
    
    var userInfo: jsonCall = jsonCall(message: Message(Stats:[], Challenges:[]))
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your Challenges"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.text = "Your Challenges"
        header.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        //header.textLabel?.font = UIFont(name: "Georgia", size: 35)
        //view.textLabel?.textColor = UIColor.white
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 35)

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    func animateTable() {
        let cells = tableView.visibleCells
        let tableWidth = tableView.bounds.size.width
        let duration = 0.75
        let delay = 0.25
        let damping:CGFloat = 0.75
        let transformation = CGAffineTransform(translationX: tableWidth, y: 0)

        let header1 = tableView.headerView(forSection: 0)!
        header1.transform = transformation
        for cell in cells {
            cell.transform = transformation
        }
        
        var index = 0
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [], animations: {
            header1.transform = CGAffineTransform.identity
        }, completion: nil)
        
        for cell in cells {
            UIView.animate(withDuration: TimeInterval(duration), delay: delay*Double(index), usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            index += 1
        }
    }
    
    var hasAppeared: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        if(hasAppeared) {
            getAllData(animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hasAppeared = true
    }
    
    @IBOutlet weak var addButton: UIButton!
    var hasData: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rowHeight = 150
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if(!hasData) {
            getAllData(animated: true)
        } else {
            tableView.reloadData {
                self.animateTable()
            }
        }
        
        addButton.layer.cornerRadius = addButton.bounds.height/2
        addButton.backgroundColor = cellColor
        //navigationController?.setNavigationBarHidden(false, animated: true)
        //navigationController?.navigationBar.alpha = 1
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.tabBarController?.tabBar.backgroundColor = UIColor.clear
        self.tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundImage = UIImage()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let amount = 125
        var tabFrame = tabBarController?.tabBar.frame
        tabFrame?.size.height = CGFloat(amount)
        tabFrame?.origin.y = self.view.frame.size.height - CGFloat(amount)
        tabBarController?.tabBar.frame = tabFrame!
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = tableView.bounds
        gradientLayer.colors = [topGradient, bottomGradient]
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = (tabBarController?.tabBar.bounds)!
        tabBarController?.tabBar.insertSubview(blurView, at: 0)
        
        self.tabBarController?.tabBar.layer.borderWidth = 0
        self.tabBarController?.tabBar.clipsToBounds = true
        
    
    }
    
   
    
    func getAllData(animated: Bool) {
        // Start Networking
        
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        let defaults = UserDefaults.standard
        let tempUsername = defaults.string(forKey: "username")
        let url = URL(string:   "http://152.3.69.115:8081/api/stats/" + tempUsername!)!
        print("Getting Data")
        //HTTPS Request
        let task = mySession.dataTask(with: url) {data, response, error in
            
            //error chekcs
            guard error == nil else {
                print("error: \(error!)")
                
                DispatchQueue.main.async {
                    let alert1 = UIAlertController(title: "No Internet Connection", message: "iPhone must be connected to internet for app to run", preferredStyle: .alert)

                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert1, animated: true)
                }
                return
            }
            
            guard let jsonData = data else {
                print("No Data")
                return
            }
            print("Got Network Data")
            
            //Decode the Json
            let decoder = JSONDecoder()
            do {
                self.userInfo = try decoder.decode(jsonCall.self, from: jsonData)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch {
                print("JSON Decode error")
            }
            
        }
        print("Resuming")
        task.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userInfo.message!.Challenges.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chalCell", for: indexPath) as! challengesTableViewCell
        // Configure the cell...
        cell.amountLabel.text = String(userInfo.message!.Challenges[indexPath.row].amount)
        cell.nameLabel.text = userInfo.message!.Challenges[indexPath.row].opponent
        cell.workoutLabel.text = userInfo.message!.Challenges[indexPath.row].workout
        cell.youAmount.text = String( userInfo.message!.Challenges[indexPath.row].you)
        cell.themAmount.text = String(userInfo.message!.Challenges[indexPath.row].them)
        cell.yourProgress.progress = Float(userInfo.message!.Challenges[indexPath.row].you) / Float(userInfo.message!.Challenges[indexPath.row].amount)
        cell.theirProgress.progress = Float(userInfo.message!.Challenges[indexPath.row].them) / Float(userInfo.message!.Challenges[indexPath.row].amount)
        let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        cell.yourProgress.transform = transform
        cell.theirProgress.transform = transform
        
        cell.mainCellLayer.layer.cornerRadius = cell.mainCellLayer.bounds.height/4
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
         
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let dest = nav.topViewController as! addScreenViewController
        dest.parentController = self
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
