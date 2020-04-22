//
//  HomeTableViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/11/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData

class workoutTableCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var mainCellLayer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var opProgressView: UIProgressView!
    @IBOutlet weak var progressView: UIProgressView!
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

class moreChallengesTableViewCell: UITableViewCell{
    
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

let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }
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
    var sectionTitles = ["Challenges", "Your Stats"]
    var sectionSizes = [3,5]
    
    var username = ""
    
    var debugging = false

    //var mainCall: jsonCall
    
    let cellGradient = false
    let topCellColor = CGColor(srgbRed: 150/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    let bottomCellColor = CGColor(srgbRed: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    //let cellColor = UIColor(red: 255/255.0, green: 190/255.0, blue: 175/255.0, alpha: 1)

    let cellColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)
    let topGradient = CGColor(srgbRed: 186.0/255, green: 159.0/255, blue: 231.0/255, alpha: 1)
    let bottomGradient = CGColor(srgbRed: 128.0/255, green: 250.0/255, blue: 255/255, alpha: 1)

    var mainCall: jsonCall = jsonCall(message: Message(Stats:[],Challenges:[]))

    @IBOutlet weak var logOutButton: UIButton!
    
    var hasAppeared: Bool = false
    var hasData: Bool = false
    override func viewWillAppear(_ animated: Bool) {
        if(hasAppeared) {getAllData(animated: false)}
        //print("Appeared")
    }

    func animateTable() {
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        let duration = 0.75
        let delay = 0.25
        let damping:CGFloat = 0.75
        let first = tableView.numberOfRows(inSection: 0)
        let transformation = CGAffineTransform(translationX: 0, y: tableHeight)

        let header1 = tableView.headerView(forSection: 0)!
        let header2 = tableView.headerView(forSection: 1)!
        header1.transform = transformation
        header2.transform = transformation
        for cell in cells {
            cell.transform = transformation
        }
        
        var index = 0
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [], animations: {
            header1.transform = CGAffineTransform.identity
        }, completion: nil)
        
        for cell in cells {
            if(index == first - 1) {
                UIView.animate(withDuration: TimeInterval(duration), delay: delay*Double(index), usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [], animations: {
                    header2.transform = CGAffineTransform.identity
                }, completion: nil)
            }
            UIView.animate(withDuration: TimeInterval(duration), delay: delay*Double(index), usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            index += 1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        hasAppeared = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getAllData(animated: true)
        if(!hasData) {
            getAllData(animated: true)
        } else {
            tableView.reloadData {
                self.animateTable()
            }
        }


        //self.view.backgroundColor = backgroundColor
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 156.0/255, green: 236.0/255, blue: 255.0/255, alpha: 1)
        logOutButton.layer.cornerRadius = logOutButton.frame.height/4
        logOutButton.layer.borderWidth = 0
        logOutButton.backgroundColor = cellColor
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

    }
        
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateView()
    }
    
    func updateView() {
        let yPos = tableView.contentOffset.y
        let amount : Int
        let offset : Int
        let offset2 : Int
        let cellSize = 100
        //print("yPos: \(yPos)")
        if(mainCall.message!.Challenges.count>3){
            amount = 4
            offset = 25
            offset2 = 50
        }
        else{
            amount = mainCall.message!.Challenges.count + 1
            offset = 25
            offset2 = 50
        }
        //print("Section Limit: \(25 + cellSize*amount)")

        let wAmount = mainCall.message!.Stats.count
        
        if(yPos > -70 && yPos <= 0) {
            if(yPos > -44) {
                tableView.headerView(forSection: 0)?.alpha = -yPos/44
                logOutButton.alpha = 0
            } else {
                tableView.headerView(forSection: 0)?.alpha = 1
                logOutButton.alpha = 1 - (yPos + 70)/26
            }
            
            tableView.headerView(forSection: 1)?.alpha = 1
            
        } else if (yPos > 0 && (yPos <= 35)) {
            logOutButton.alpha = 0
            tableView.headerView(forSection: 0)?.alpha = 0
            tableView.headerView(forSection: 1)?.alpha = 1
            
        } else if(yPos > 35) && (Int(yPos) <= (offset2 + cellSize*amount)) {
            tableView.headerView(forSection: 1)?.alpha = 1
            tableView.headerView(forSection: 0)?.alpha = 0
            logOutButton.alpha = 0
            let index = Int(floor(Float(yPos - 35)/Float(cellSize)))
            let alphaX = Float(yPos - 35).truncatingRemainder(dividingBy: Float(cellSize))
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) else {
                print("Avoided error")
                return
            }
            cell.alpha = CGFloat(1 - (alphaX)/35)
            
            var nextCell : UITableViewCell
            if(index < amount - 1) {
                for n in (index + 1)...amount - 1 {
                    nextCell = tableView.cellForRow(at: IndexPath(row: n, section: 0))!
                    nextCell.alpha = 1
                }
            }
            if(index > 0 && alphaX < 35) {
                guard let incomingCell = tableView.cellForRow(at: IndexPath(row: index - 1, section: 0)) else {
                    print("Avoided Error Over here")
                    return
                }
                incomingCell.alpha = 0
            }
        } else if (Int(yPos) > (offset2 + cellSize*amount) && Int(yPos) <= offset + offset2 + cellSize*amount) {
            logOutButton.alpha = 0
            
            let slope = ((offset2 + cellSize*amount) - (offset + offset2 + cellSize*amount))
            let alphaX = Float((offset2 + cellSize*amount) - Int(yPos))/Float(slope)
            tableView.headerView(forSection: 1)?.alpha = CGFloat(1 - alphaX)
            print(alphaX)
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) else {
                return
            }
            cell.alpha = 1
            
            guard let cell2 = tableView.cellForRow(at: IndexPath(row: amount - 1, section: 0)) else {
                return
            }
            cell2.alpha = 0
            
        } else if (Int(yPos) > offset + offset2 + cellSize*amount) && (wAmount > 0) {
            tableView.headerView(forSection: 1)?.alpha = 0
            logOutButton.alpha = 0
            let index = Int(floor(Float((Int(yPos) - offset))/Float(cellSize))) - (amount + 1)
            let alphaX = Float(Int(yPos) - offset).truncatingRemainder(dividingBy: Float(cellSize))
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 1)) else {
                return
            }

            cell.alpha = CGFloat(1 - (alphaX)/35)
            var nextCell : UITableViewCell
            if(index < wAmount - 1) {
                for n in (index + 1)...wAmount - 1 {
                    nextCell = tableView.cellForRow(at: IndexPath(row: n, section: 1))!
                    nextCell.alpha = 1
                }
            }
            if(index > 0 && Int(alphaX) < 35) {
                guard let incomingCell = tableView.cellForRow(at: IndexPath(row: index - 1, section: 1)) else {
                    return
                }
                incomingCell.alpha = 0
            }
        } else if(yPos <= -88) {
            logOutButton.alpha = 1
            tableView.headerView(forSection: 0)?.alpha = 1
            for n in tableView.visibleCells {
                n.alpha = 1
            }
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {
                return
            }
            cell.alpha = 1
        }
    }
    
    func getAllData(animated: Bool) {
        
        // 2. BEGIN NETWORKING code
        //
        if(animated) {
                    createSpinnerView()
        }
                let mySession = URLSession(configuration: URLSessionConfiguration.default)
                
                let defaults = UserDefaults.standard
                let tempUsername = defaults.string(forKey: "username")
                    
                let url = URL(string: "http://152.3.69.115:8081/api/stats/" + tempUsername!)!

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
                        self.hasData = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData {
                                self.tableView.layoutIfNeeded()
                                if(animated) {
                                    self.removeSpinnerView()
                                    self.animateTable()
                                } else {
                                    self.updateView()
                                }
                            }
                        }
                        
                    } catch {
                        print("JSON Decode error")
                    }
                }

            // actually make the http task run.
            task.resume()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            if(mainCall.message!.Challenges.count>=3){
                return 4
            }
            else if(hasData){
                return mainCall.message!.Challenges.count + 1
            } else {
                return 0
            }
        } else {
            return mainCall.message!.Stats.count
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (hasData) {
            return 2 //Challenges + workout
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Checking for data from \(mainCall)")
        if(indexPath.section == 0) {
            if((indexPath.row<3 && mainCall.message!.Challenges.count>=3) || mainCall.message!.Challenges.count != 0 && (indexPath.row<mainCall.message!.Challenges.count && mainCall.message!.Challenges.count<3)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
                cell.progressView.progress = Float(mainCall.message!.Challenges[indexPath.row].you) / Float(mainCall.message!.Challenges[indexPath.row].amount)
                cell.opProgressView.progress = Float(mainCall.message!.Challenges[indexPath.row].them) / Float(mainCall.message!.Challenges[indexPath.row].amount)
                let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 5.0)
                cell.progressView.transform = transform
                cell.opProgressView.transform = transform
                //cell.amountLabel.text = String( mainCall.message.Challenges[indexPath.row].amount)
                cell.workoutLabel.text = mainCall.message!.Challenges[indexPath.row].workout
                cell.challengeLabel.text = mainCall.message!.Challenges[indexPath.row].opponent
                cell.mainCellLayer.layer.cornerRadius = cell.mainCellLayer.bounds.height/4
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
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "moreChallengesTableViewCell", for: indexPath) as! moreChallengesTableViewCell
                
                cell.mainCellLayer.layer.cornerRadius = cell.mainCellLayer.frame.height/4
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workCell", for: indexPath) as! workoutTableCell
            cell.amountLabel.text = String(mainCall.message!.Stats[indexPath.row].amount)
            cell.workoutLabel.text = mainCall.message!.Stats[indexPath.row].workout
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
            return cell
        }
    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        //let label = UILabel()
//        //label.text = sectionTitles[section]
//        //return label
//    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.text = sectionTitles[section]
        header.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        //header.textLabel?.font = UIFont(name: "Georgia", size: 35)
        //view.textLabel?.textColor = UIColor.white
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 35)

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let myRow = tableView!.indexPathForSelectedRow

        if(myRow?.section==0){
            let destVC = segue.destination as! challengesTableViewController
            destVC.userInfo = mainCall
            destVC.hasData = true
        }
        else{
            let myCurrentCell = tableView!.cellForRow(at: myRow!) as! workoutTableCell
            let destVC = segue.destination as! workoutViewController
            destVC.nameText = myCurrentCell.workoutLabel.text!
            print("two")
        }
                    
        //destVC.place = (myCurrentCell.places?.text)!
        //destVC.weatherPic = (myCurrentCell.weatherIcon?.image)!
        //destVC.temp = (myCurrentCell.temperature?.text)!
        
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var segue: String!
//        if indexPath.section == 0 {
//            if(indexPath.row<5){
//                segue = "segue1"
//            }
//            else{
//                segue = "segue3"
//            }
//        } else  {
//            segue = "segue2"
//        }
//
//
//        self.performSegue(withIdentifier: segue, sender: self)
//    }
//

    
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
    
    var spinner: UIViewController?
    
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
        spinner!.view.transform = CGAffineTransform(translationX: 0, y: -(navigationController?.navigationBar.bounds.height)! - 50)
        view.addSubview(spinner!.view)
        spinner!.didMove(toParent: self)
    }
    
    func removeSpinnerView() {
        self.spinner!.willMove(toParent: nil)
        self.spinner!.view.removeFromSuperview()
        self.spinner!.removeFromParent()
    }

}
