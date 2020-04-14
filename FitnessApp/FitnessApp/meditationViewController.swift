//
//  meditationViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/3/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData


class meditationViewController: UIViewController {

    @IBOutlet weak var averagetimeLabel: UILabel!
    @IBOutlet weak var newSessionButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    
    var sessions: [NSManagedObject] = []
    var average: String = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Session")
        
        do {
            var total: Int = 0
            sessions = try context.fetch(request)
            for session in sessions {
                if session.value(forKey: "time") != nil {
                    total += (session.value(forKey: "time") as! Int)
                }
            }
            average = String(total/7)
            averagetimeLabel.text = average + " mins/day"
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newSessionButton.layer.cornerRadius = 6
        newSessionButton.layer.borderWidth = 1
        newSessionButton.layer.borderColor = UIColor.black.cgColor
        
        moreInfoButton.layer.cornerRadius = 6
        moreInfoButton.layer.borderWidth = 1
        moreInfoButton.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
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
