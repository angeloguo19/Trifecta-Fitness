//
//  focusViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/7/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class focusViewController: UIViewController {
    
    var nameText: String = ""
    var waitNum: Int = 0
    var servingsNum: Int = 0
    var allInstructions: String = ""
    var foodImage: UIImage?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var foodPicture: UIImageView!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameLabel.text = nameText
        timeLabel.text = "Total Time: " + String(waitNum) + " mins"
        servingsLabel.text = "Servings: " + String(servingsNum)
        instructionsLabel.text = allInstructions
        foodPicture.image = foodImage
        
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
