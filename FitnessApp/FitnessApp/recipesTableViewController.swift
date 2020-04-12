//
//  recipesTableViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/7/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
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

class recipesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var waitTime: Int = 0
    var totalServings: Int = 0
    var recipeId: Int = 0
    var instruction: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class recipesTableViewController: UITableViewController {
    
    var search: String = ""
    var urls: URL?
    var temp: String = ""
    var ids: Int = 0
    
    var totalRecipes: AllRecipes = AllRecipes(results: [])
    
    struct AllRecipes: Codable {
        var results: [Recipes]
    }
    
    struct Recipes: Codable {
        var id: Int
        var image: String
        var readyInMinutes: Int
        var servings: Int
        var title: String
    }
    /*
    var totalInstructions: Information = Information(extendedIngredients: [], instructions: "")
    
    struct Information: Codable {
        var extendedIngredients: [Ingredients]
        var instructions: String
    }
    
    struct Ingredients: Codable {
        var amount: Double
        var unit: String
        var originalName: String
        var original: String
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllData()
    
    }
    
    func getAllData() {
        
        // 2. BEGIN NETWORKING code
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        //hard code 25 results at end
        let link: String = "https://api.spoonacular.com/recipes/search?query=" + search + "&number=2&instructionsRequired=true&apiKey=611d546c1bc54cf8baa25037850009d7"
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
        
        // 4. DECODE THE RESULTING JSON
        //
            let decoder = JSONDecoder()
            //print(String(data: jsonData, encoding: .utf8))

            do {
                // decode the JSON into our array of todoItem's
                self.totalRecipes = try decoder.decode(AllRecipes.self, from: jsonData)
                                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("JSON Decode error")
            }
        }
     
        // actually make the http task run.
        task.resume()
    }
    /*
    func getData() {
        
        // 2. BEGIN NETWORKING code
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        //hard code 25 results at end
        let link: String = "https://api.spoonacular.com/recipes/" + String(ids) + "/information?includeNutrition=false&apiKey=611d546c1bc54cf8baa25037850009d7"
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
        
        // 4. DECODE THE RESULTING JSON
        //
            let decoder = JSONDecoder()
            //print(String(data: jsonData, encoding: .utf8))

            do {
                // decode the JSON into our array of todoItem's
                self.totalInstructions = try decoder.decode(Information.self, from: jsonData)
                                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("JSON Decode error")
            }
        }
     
        // actually make the http task run.
        task.resume()
    }
 */
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return totalRecipes.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! recipesTableViewCell
        
        temp = "https://spoonacular.com/recipeImages/" +  totalRecipes.results[indexPath.row].image
        urls = URL(string: temp)
        //cell.recipeImage.load(url: urls!))

        cell.recipeLabel.text = totalRecipes.results[indexPath.row].title
        cell.waitTime = totalRecipes.results[indexPath.row].readyInMinutes
        cell.totalServings = totalRecipes.results[indexPath.row].servings
        cell.recipeId = totalRecipes.results[indexPath.row].id
        
        //getData()
        //cell.instruction = totalInstructions.instructions

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! focusViewController
        let myRow = tableView!.indexPathForSelectedRow
        let myCurrCell = tableView.cellForRow(at: myRow!) as! recipesTableViewCell
        
        destVC.nameText = (myCurrCell.recipeLabel!.text)!
        destVC.waitNum = (myCurrCell.waitTime)
        destVC.servingsNum = (myCurrCell.totalServings)
        //destVC.allInstructions = (myCurrCell.instruction)
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
