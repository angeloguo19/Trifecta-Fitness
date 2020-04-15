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
        
        // Calculate average meditation time for past 7 days
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        request.returnsObjectsAsFaults = false
        do {
            var total: Int = 0
            let result = try context.fetch(request)
            sessions = result as! [NSManagedObject]
            for session in sessions {
                total += (session.value(forKey: "time") as! Int)
            }
            average = String(total/7)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        averagetimeLabel.text = average + " mins/day"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newSessionButton.layer.cornerRadius = 6
        newSessionButton.layer.borderWidth = 1
        newSessionButton.layer.borderColor = UIColor.black.cgColor
        
        moreInfoButton.layer.cornerRadius = 6
        moreInfoButton.layer.borderWidth = 1
        moreInfoButton.layer.borderColor = UIColor.black.cgColor
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let topGradient = CGColor(srgbRed: 255/255.0, green: 159.0/255.0, blue: 231.0/255.0, alpha: 1)
        let bottomGradient = CGColor(srgbRed: 255/255.0, green: 179/255.0, blue: 71/255.0, alpha: 1)
        let gradientView = CAGradientLayer()
        gradientView.frame = view.layer.bounds
        gradientView.colors = [topGradient, bottomGradient]
        view.layer.insertSublayer(gradientView, at: 0)

        // MARK: Core Data Call
        // Get today's date
        let calendar = Calendar(identifier: .gregorian)
        let units: Set<Calendar.Component> = [.year, .month, .day]
        let components = calendar.dateComponents(units, from: Date())
        let date: NSDate = calendar.date(from: components)! as NSDate
        
        // Get specific time data for past 7 days
        
        
    
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
