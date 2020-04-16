//
//  workoutViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/5/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreData

class workoutViewController: UIViewController {
    
    var nameText: String = ""
    
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet weak var reps: UITextField!
    
    let defaults = UserDefaults.standard
    
    @IBAction func updateStat(_ sender: UIButton) {
        let rep = (reps.text! as NSString).integerValue
        let workout = nameText
        var current = defaults.integer(forKey: workout)
        current = current + rep
        defaults.set(current, forKey: workout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        workoutNameLabel.text = nameText

        workoutNameLabel.layer.borderColor = UIColor.black.cgColor
        workoutNameLabel.layer.borderWidth = 1
       
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
