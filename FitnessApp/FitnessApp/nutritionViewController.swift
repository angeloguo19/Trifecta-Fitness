//
//  nutritionViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/3/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class nutritionViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchButton.setImage(UIImage(named: "search"), for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is recipesTableViewController
        {
            let vc = segue.destination as? recipesTableViewController
            vc?.search = searchTextField.text!
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

}
