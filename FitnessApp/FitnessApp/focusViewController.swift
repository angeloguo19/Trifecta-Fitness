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
    var id: Int = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = nameText
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
