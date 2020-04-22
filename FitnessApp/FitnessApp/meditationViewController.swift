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

extension NSDate {
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date)
    }
}

class meditationViewController: UIViewController {

    @IBOutlet weak var averagetimeLabel: UILabel!
    @IBOutlet weak var newSessionButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var chartView: BarChartView!
    
    
    
    var average: String = ""
    var pastWeekTimes: [Double] = [0,0,0,0,0,0,0]
    var days = [NSDate]()
    var actualdays = [String]()
    var xs = [String]()
    var ys = [Double]()
    
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

        let calendar = Calendar(identifier: .gregorian)
        let units: Set<Calendar.Component> = [.year, .month, .day]
        let components = calendar.dateComponents(units, from: Date())
        let date: NSDate = calendar.date(from: components)! as NSDate

        days.append(date)
        actualdays.append(change(date.dayOfTheWeek()!))
        
        for i in 1 ... 6 {
            let day = Calendar.current.date(byAdding: .day, value: -i, to: date as Date)!
            days.append(day as NSDate)
            actualdays.append(change((day as NSDate).dayOfTheWeek()!))
        }

        // Retrieve Session entity's and update pastWeekTimes array
        var results: [NSManagedObject] = []
        let requests = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        requests.returnsObjectsAsFaults = false
        do {
            let fetchResult = try context.fetch(requests)
            results = fetchResult as! [NSManagedObject]
            for result in results {
                let tempdate: NSDate = result.value(forKey: "date") as! NSDate
                let temptime = result.value(forKey: "time") as! Int
                var isIn: Int = 0
                for n in 0 ... 6 {
                    if tempdate == days[n] {
                        pastWeekTimes[n] = Double(temptime)
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

        // Make Bar Graph
        xs = actualdays
        ys = pastWeekTimes
        xs.reverse()
        ys.reverse()
        setChart(labels: xs, values: ys)
    
    }
    
    func change(_ today:String) -> String {
        if today == "Sunday" {
            return "Sun"
        }
        if today == "Monday" {
            return "Mon"
        }
        if today == "Tuesday" {
            return "Tues"
        }
        if today == "Wednesday" {
            return "Wed"
        }
        if today == "Thursday" {
            return "Thurs"
        }
        if today == "Friday" {
            return "Fri"
        }
        if today == "Saturday" {
            return "Sat"
        }
        return today
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
        chartView.legend.enabled = false
        chartView.animate(yAxisDuration: 1)
        chartView.leftAxis.axisMinimum = 0.0
        chartView.rightAxis.enabled = false

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


