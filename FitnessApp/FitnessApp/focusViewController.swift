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
    var foodImage: UIImage?
    var allInstructions: String = ""
    var ingredientsText: String = ""

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var foodPicture: UIImageView!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameLabel.text = nameText
        timeLabel.text = "Total Time: " + String(waitNum) + " mins"
        servingsLabel.text = "Servings: " + String(servingsNum)
        foodPicture.image = foodImage
        instructionsLabel.text = allInstructions
        ingredientsLabel.text = ingredientsText
        
        // UI for ViewController
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let topGradient = CGColor(srgbRed: 110.0/255, green: 225.0/255, blue: 245/255, alpha: 1)
        let bottomGradient = CGColor(srgbRed: 240/255, green: 240/255, blue: 245/255, alpha: 1)
        let gradientView = CAGradientLayer()
        gradientView.frame = view.layer.bounds
        gradientView.colors = [topGradient, bottomGradient].reversed()
        view.layer.insertSublayer(gradientView, at: 0)
        
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
