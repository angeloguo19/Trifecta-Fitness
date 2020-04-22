//
//  fitnessTableViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/5/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData

class fitnessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainCellLayer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var progress: Int = 0
    var leaderboard: String = ""
    var tutorial: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


class fitnessTableViewController: UITableViewController {
    
//    var workouts = ["Push-Ups", "Tricep Dips", "Pull-Ups", "Sit-Ups", "Crunches", "Burpees", "Glute Bridges", "Squats", "Forward Lunges", "Calf Raises"]
    let defaults = UserDefaults.standard

    let cellGradient = false
    let topCellColor = CGColor(srgbRed: 150/255.0, green: 222/255.0, blue: 192/255.0, alpha: 1)
    let bottomCellColor = CGColor(srgbRed: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    //let cellColor = UIColor(red: 255/255.0, green: 190/255.0, blue: 175/255.0, alpha: 1)
    let cellColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)

    let topGradient = CGColor(srgbRed: 185/255.0, green: 239/255.0, blue: 213/255.0, alpha: 1)
    //let bottomGradient = CGColor(srgbRed: 253/255.0, green: 253/255.0, blue: 150/255.0, alpha: 1)
    let bottomGradient = CGColor(srgbRed: 243/255.0, green: 193/255.0, blue: 85/255.0, alpha: 1)
    //let bottomGradient = CGColor(srgbRed: 255/255.0, green: 159.0/255.0, blue: 231.0/255.0, alpha: 1)
        
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos = scrollView.contentOffset.y
        let amount : Int
        let cellSize = 100
        let array = defaults.object(forKey: "WorkoutsArray") as? [String] ?? [String]()
        amount = array.count
        if(yPos > -70 && yPos <= 0) {
           
           if(yPos > -44) {
               tableView.headerView(forSection: 0)?.alpha = -yPos/44
           } else {
               tableView.headerView(forSection: 0)?.alpha = 1
           }
           
           tableView.headerView(forSection: 1)?.alpha = 1
            guard let nextCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {
                return
            }
            nextCell.alpha = 1
           
        } else if (yPos > 0 && (yPos <= 35)) {
           tableView.headerView(forSection: 0)?.alpha = 0
        } else if (yPos > 35) {
           tableView.headerView(forSection: 0)?.alpha = 0
           let index = Int(floor(Float(yPos - 35)/Float(cellSize)))
           let alphaX = Float(yPos - 35).truncatingRemainder(dividingBy: Float(cellSize))
           let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            
             //print("YPos: \(yPos), AlphaX: \(alphaX), Index: \(index), AlphaToSet: \(CGFloat(1 - (alphaX)/35))")

            cell!.alpha = CGFloat(1 - (alphaX)/35)
            if(index < amount - 1) {
                for n in (index + 1)...(index + tableView.visibleCells.count - 1) {
                    guard let nextCell = tableView.cellForRow(at: IndexPath(row: n, section: 0)) else {
                        return
                    }
                    nextCell.alpha = 1
                }
            }
            
           if(index > 0 && alphaX < 35) {
                guard let incomingCell = tableView.cellForRow(at: IndexPath(row: index - 1, section: 0)) else {
                    return
                }
                incomingCell.alpha = 0
           }
            

        } else {
            tableView.headerView(forSection: 0)?.alpha = 1
            for n in tableView.visibleCells {
                n.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = CAGradientLayer()
        gradientView.colors = [topGradient, bottomGradient]
        gradientView.frame = tableView.layer.bounds
        let backgroundView = UIView(frame: tableView.layer.bounds)
        backgroundView.layer.insertSublayer(gradientView, at: 0)
        tableView.backgroundView = backgroundView
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.text = "Workouts"
        header.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 35)
         //view.textLabel?.textColor = UIColor.white
        header.textLabel?.textColor = UIColor.black
    }

//      //1
//      guard let appDelegate =
//        UIApplication.shared.delegate as? AppDelegate else {
//          return
//      }
//
//      let context =
//        appDelegate.persistentContainer.viewContext
//
//      //2
//      let fetchRequest =
//        NSFetchRequest<NSManagedObject>(entityName: "Workout")
//
//      //3
//      do {
//        workouts = try context.fetch(fetchRequest)
//      } catch let error as NSError {
//        print("Could not fetch. \(error), \(error.userInfo)")
//      }
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return("Workouts")
    }
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workouts = defaults.object(forKey: "WorkoutsArray") as? [String] ?? [String]()
        return workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fitnessCell", for: indexPath) as! fitnessTableViewCell
        
        let workouts = defaults.object(forKey: "WorkoutsArray") as? [String] ?? [String]()
        let workout = workouts[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.clear
        cell.mainCellLayer.layer.cornerRadius = cell.mainCellLayer.bounds.height/4
        cell.mainCellLayer.clipsToBounds = true
        if cellGradient {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = cell.mainCellLayer.bounds
            gradientLayer.colors = [topCellColor, bottomCellColor]
            cell.mainCellLayer.layer.insertSublayer(gradientLayer, at: 0)
        }
        cell.mainCellLayer.backgroundColor = cellColor
        cell.nameLabel.text = workout
        //cell.statLabel.text = String(defaults.integer(forKey: workout))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! workoutViewController
        let myRow = tableView!.indexPathForSelectedRow
        let myCurrCell = tableView.cellForRow(at: myRow!) as! fitnessTableViewCell
        
        destVC.nameText = (myCurrCell.nameLabel!.text)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
  
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

   

}
