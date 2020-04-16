//
//  meditationViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/3/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData
import Charts


class meditationViewController: UIViewController {

    @IBOutlet weak var averagetimeLabel: UILabel!
    @IBOutlet weak var newSessionButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var chartView: LineChartView!
    
    
    
    var average: String = ""
    var pastWeekTimes: [Int] = [0,0,0,0,0,0,0]
    var days = [NSDate]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var sessions: [NSManagedObject] = []
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
        
        var lineChartEntry = [ChartDataEntry]()
        for i in 0...100 {
            lineChartEntry.append(ChartDataEntry.init(x: Double(i), y: sin(Double(i)/(4*3.14))))
        }
        let values = LineChartDataSet(entries: lineChartEntry, label: "Sine Function")
        values.colors = [NSUIColor.blue]
        let data = LineChartData()
        data.addDataSet(values)
        chartView.data = data
        chartView.chartDescription?.text = "Random Numbers to show Sergio It works XD"
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let topGradient = CGColor(srgbRed: 255/255.0, green: 159.0/255.0, blue: 231.0/255.0, alpha: 1)
        let bottomGradient = CGColor(srgbRed: 255/255.0, green: 179/255.0, blue: 71/255.0, alpha: 1)
        let gradientView = CAGradientLayer()
        gradientView.frame = view.layer.bounds
        gradientView.colors = [topGradient, bottomGradient]
        view.layer.insertSublayer(gradientView, at: 0)

        // MARK: Core Data Call
        
        // Get NSDate for past 7 days
        let calendar = Calendar(identifier: .gregorian)
        let units: Set<Calendar.Component> = [.year, .month, .day]
        let components = calendar.dateComponents(units, from: Date())
        let date: NSDate = calendar.date(from: components)! as NSDate
        days.append(date)
        for i in 1 ... 6 {
            let day = Calendar.current.date(byAdding: .day, value: -i, to: date as Date)!
            days.append(day as NSDate)
        }
        
        // Retrieve Session entity's and update pastWeekTimes array
        var results: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        request.returnsObjectsAsFaults = false
        do {
            let fetchResult = try context.fetch(request)
            results = fetchResult as! [NSManagedObject]
            for result in results {
                let tempdate: NSDate = result.value(forKey: "date") as! NSDate
                let temptime = result.value(forKey: "time") as! Int
                var isIn: Int = 0
                for n in 0 ... 6 {
                    if tempdate == days[n] {
                        pastWeekTimes[n] = temptime
                        isIn = 1
                    }
                }
                if isIn == 0 {
                    context.delete(result)
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print(pastWeekTimes)
    
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
