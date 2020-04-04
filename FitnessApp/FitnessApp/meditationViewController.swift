//
//  meditationViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/3/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit



class meditationViewController: UIViewController {

    @IBOutlet weak var averagetimeLabel: UILabel!
    @IBOutlet weak var newSessionButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newSessionButton.layer.cornerRadius = 6
        newSessionButton.layer.borderWidth = 1
        newSessionButton.layer.borderColor = UIColor.black.cgColor
        
        moreInfoButton.layer.cornerRadius = 6
        moreInfoButton.layer.borderWidth = 1
        moreInfoButton.layer.borderColor = UIColor.black.cgColor
        
        
        averagetimeLabel.text = " mins/day"
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
