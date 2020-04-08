//
//  recipesTableViewController.swift
//  FitnessApp
//
//  Created by codeplus on 4/7/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class recipesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeLabel: UILabel!
    
    var waitTime: String = ""
    var servings: Int = 0
    
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
    var allRecipes: [Recipes] = []
    
    struct Fetch: Codable {
        var results: String
    }
    
    struct Recipes: Codable {
        var id: Int
        //var image: UIImage
        var readyInMinutes: Int
        var servings: Int
        var title: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //getAllData()
    
    }
    /*
    func getAllData() {
        
        // 2. BEGIN NETWORKING code
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
     
        let link: String = "https://api.spoonacular.com/recipes/search?query=" + search + "&number=2&instructionsRequired=true"
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

            do {
                // decode the JSON into our array of todoItem's
                self.allRecipes = try decoder.decode([DBZ].self, from: jsonData)
                                
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
        // #warning Incomplete implementation, return the number of rows
        return 1//allRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! recipesTableViewCell

        //cell.recipeLabel.text = allRecipes[indexPath.row].title

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! focusViewController
        let myRow = tableView!.indexPathForSelectedRow
        let myCurrCell = tableView.cellForRow(at: myRow!) as! recipesTableViewCell
        
        
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
