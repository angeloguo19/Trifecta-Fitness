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
    @IBOutlet weak var chartView: BarChartView!
    
    
    
    var average: String = ""
    var pastWeekTimes: [Int] = [25,15,60,5,30,15,0]
    var days = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Calculate average meditation time for past 7 days
        var sessions: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        request.returnsObjectsAsFaults = false
        do {
            var total = 0
            let result = try context.fetch(request)
            sessions = result as! [NSManagedObject]
            for session in sessions {
                total += (session.value(forKey: "time") as! Int)
            }
            average = String(Int(round(Double(total)/7.0)))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        averagetimeLabel.text = average + " mins/day"
    
        // MARK: Core Data Call
        
        // Get NSDate for past 7 days
//        let calendar = Calendar(identifier: .gregorian)
//        let units: Set<Calendar.Component> = [.year, .month, .day]
//        let components = calendar.dateComponents(units, from: Date())
//        let date: NSDate = calendar.date(from: components)! as NSDate
//        days.append(date)
//        for i in 1 ... 6 {
//            let day = Calendar.current.date(byAdding: .day, value: -i, to: date as Date)!
//            days.append(day as NSDate)
//        }
//
//        // Retrieve Session entity's and update pastWeekTimes array
//        var results: [NSManagedObject] = []
//        let requests = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
//        requests.returnsObjectsAsFaults = false
//        do {
//            let fetchResult = try context.fetch(requests)
//            results = fetchResult as! [NSManagedObject]
//            for result in results {
//                let tempdate: NSDate = result.value(forKey: "date") as! NSDate
//                let temptime = result.value(forKey: "time") as! Int
//                var isIn: Int = 0
//                for n in 0 ... 6 {
//                    if tempdate == days[n] {
//                        pastWeekTimes[n] = temptime
//                        isIn = 1
//                    }
//                }
//                if isIn == 0 {
//                    context.delete(result)
//                    do {
//                        try context.save()
//                    } catch let error as NSError {
//                        print("Could not save. \(error), \(error.userInfo)")
//                    }
//                }
//            }
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//
//        // Make Line Graph
//        var lineChartEntry = [ChartDataEntry]()
//        for i in 0...6 {
//            lineChartEntry.append(ChartDataEntry.init(x: Double(i+1), y: Double(pastWeekTimes[i])))
//        }
//        let values = LineChartDataSet(entries: lineChartEntry, label: "Time Spent Meditating")
//        values.colors = [NSUIColor.blue]
//        let data = LineChartData()
//        data.addDataSet(values)
//        chartView.data = data
//        // Customize Line Graph
//        chartView.xAxis.labelPosition = .bottom
//        chartView.leftAxis.axisMinimum = 0.0
//        chartView.rightAxis.enabled = false
//        //chartView.chartDescription?.text = "Meditation time over past week"
    
        //BarChartDataEntry(value)
    
    }
    func setChart(labels: [String], values: [Double]) {
        chartView.noDataText = "You need to provide data for the chart."
        let formato:BarChartFormatter = BarChartFormatter()
        formato.setDays(Days: labels)
        let xAxis = XAxis()
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
            //formato.stringForValue(Double(i), axis: xAxis)
        }
        xAxis.valueFormatter = formato
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        chartView.xAxis.labelPosition = .bottom
        let chartDataSet = BarChartDataSet(dataEntries)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
    }
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter {
        var days = [String]()
        
        public func setDays(Days: [String]) {
            days = Days
        }
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return(days[Int(value)])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let unitsSold:[Double] = [5, 15, 10, 30, 60, 10, 20]
        let days = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
        setChart(labels: days, values: unitsSold)
        
        // UI for ViewController
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let topGradient = CGColor(srgbRed: 255/255.0, green: 159.0/255.0, blue: 231.0/255.0, alpha: 1)
        let bottomGradient = CGColor(srgbRed: 255/255.0, green: 179/255.0, blue: 71/255.0, alpha: 1)
        let gradientView = CAGradientLayer()
        gradientView.frame = view.layer.bounds
        gradientView.colors = [topGradient, bottomGradient].reversed()
        view.layer.insertSublayer(gradientView, at: 0)
        
        let buttColor = UIColor(red: 239/255.0, green: 245/255.0, blue: 214/255.0, alpha: 1)
        // UI for Buttons
        newSessionButton.layer.cornerRadius = newSessionButton.frame.height/4
        newSessionButton.layer.borderWidth = 0
        newSessionButton.layer.borderColor = UIColor.black.cgColor
        newSessionButton.backgroundColor = buttColor
        
        moreInfoButton.layer.cornerRadius = moreInfoButton.frame.height/4
        moreInfoButton.layer.borderWidth = 0
        moreInfoButton.layer.borderColor = UIColor.black.cgColor
        moreInfoButton.backgroundColor = buttColor//(red: 150/255.0, green: 150/255.0, blue: 255/255.0, alpha: 1)

    }
    
    
}

  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


