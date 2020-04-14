//
//  CreateAccountViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/14/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var createAccount: UIButton!
    @IBAction func createButton(_ sender: Any) {
        // Call oliver api and see if username can be created
        //If so, set username and then dismiss
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
