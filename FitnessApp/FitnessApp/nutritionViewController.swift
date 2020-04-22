//
//  nutritionViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/3/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

extension UIImageView {
    func loads(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class nutritionViewController: UIViewController, UITextFieldDelegate {

/*
    var everything: [Information] =
    
    struct Information: Codable {
        title: String
        image: String
        servings: Int
        readyInMinutes: Int
        var extendedIngredients: [Ingredients]
        var instructions: String
    }
    struct Ingredients: Codable {
        var originalString: String
    }
    */
    
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var properSearch: String = ""
    
    @objc func donePicker() {
        searchTextField.resignFirstResponder()
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        searchButton.layer.cornerRadius = 5
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
        
        // Make done button
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        searchTextField.inputAccessoryView = toolBar
        
        // UI for ViewController
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //let topGradient = CGColor(srgbRed: 95/255.0, green: 198/255.0, blue: 202/255.0, alpha: 1)
        //let bottomGradient = CGColor(srgbRed: 249/255.0, green: 184/255.0, blue: 170/255.0, alpha: 1)
        let topGradient = CGColor(srgbRed: 110.0/255, green: 225.0/255, blue: 245/255, alpha: 1)
        let bottomGradient = CGColor(srgbRed: 240/255, green: 240/255, blue: 245/255, alpha: 1)
        let gradientView = CAGradientLayer()
        gradientView.frame = view.layer.bounds
        gradientView.colors = [topGradient, bottomGradient].reversed()
        view.layer.insertSublayer(gradientView, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is recipesTableViewController
        {
            properSearch = searchTextField.text!
            let vc = segue.destination as? recipesTableViewController
            vc?.search = properSearch.replacingOccurrences(of: " ", with: "_")
        }
    }
    
    
    func getmoreData() {
        
        // 2. BEGIN NETWORKING code
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        let link: String = "https://api.spoonacular.com/recipes/informationBulk?ids=729431,809898,735148&apiKey=3779cda1cd174fa1b8677bd02ba7ba90"

        let url = URL(string: link)!

        // 3. MAKE THE HTTPS REQUEST task
        let alert1 = UIAlertController(title: "No Internet Connection", message: "iPhone must be connected to internet for app to run", preferredStyle: .alert)
        
        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let task = mySession.dataTask(with: url) { data, response, error in

            // ensure there is no error for this HTTP response
            guard error == nil else {
                DispatchQueue.main.async {
                    self.present(alert1, animated: true)
                }
                return
            }
            // ensure there is data returned from this HTTP response
            guard let jsonData = data else {
                print("No data")
                return
            }
            print("Got the data from network")
        /*
        // 4. DECODE THE RESULTING JSON
            let decoder = JSONDecoder()
            do {
                self.totalInstructions = try decoder.decode([Information].self, from: jsonData)
                        
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("JSON Decode error")
            }
        }
        task.resume()
    }
             */}}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
