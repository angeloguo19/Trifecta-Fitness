//
//  LaunchScreenViewController.swift
//  FitnessApp
//
//  Created by Oliver Adolfo Rodas on 4/20/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("hi")
        
        let defaults = UserDefaults.standard
        let tempUsername = defaults.string(forKey: "username")
        if(tempUsername != nil){
            print(tempUsername)
            self.performSegue(withIdentifier: "loggedIn", sender: self)
            print("wtf")
        }
        else{
            self.performSegue(withIdentifier: "notLoggedIn", sender: self)
            print("yo")
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
