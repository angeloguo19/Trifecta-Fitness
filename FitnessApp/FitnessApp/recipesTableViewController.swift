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
    var ids: String = ""
    
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
    
    var totalInstructions: [Information] = [Information(extendedIngredients: [], instructions: "")]
    
    struct Information: Codable {
        var extendedIngredients: [Ingredients]
        var instructions: String
    }
    
    struct Ingredients: Codable {
        //var amount: Double
        //var unit: String
        //var originalName: String
        var originalString: String
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllData()
        
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        
        let topGradient = CGColor(srgbRed: 110.0/255, green: 225.0/255, blue: 245/255, alpha: 1)
        let bottomGradient = CGColor(srgbRed: 240/255, green: 240/255, blue: 245/255, alpha: 1)
        let gradientView = CAGradientLayer()
        gradientView.frame = tableView.layer.bounds
        gradientView.colors = [topGradient, bottomGradient].reversed()
        let backgroundView = UIView(frame: tableView.layer.bounds)
        backgroundView.layer.insertSublayer(gradientView, at: 0)
        tableView.backgroundView = backgroundView
    }
    
    func getAllData() {
        
        // 2. BEGIN NETWORKING code
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        //hard code 25 results at end
        var url: URL = URL(string: "http://www.google.com")!
        let link: String = "https://api.spoonacular.com/recipes/search?query=" + search + "&number=1&instructionsRequired=true&apiKey=3779cda1cd174fa1b8677bd02ba7ba90"
        if URL(string: link) == nil {
            let alert3 = UIAlertController(title: "Search Error", message: "Please make sure that the recipe name entered contains letters only", preferredStyle: .alert)
            alert3.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert3, animated: true)
        } else {
            url = URL(string: link)!
        }
        

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
                
                if self.totalRecipes.results.count == 0 {
                    let alert2 = UIAlertController(title: "No Search Results", message: "We were unable to find a recipe for the search you made", preferredStyle: .alert)
                    
                    alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert2, animated: true)
                    }
                }
                
                if self.totalRecipes.results.count > 0 {
                    self.ids = String(self.totalRecipes.results[0].id)
                    if  self.totalRecipes.results.count > 1 {
                        for num in (1...self.totalRecipes.results.count-1) {
                            self.ids.append(",")
                            self.ids.append(String(self.totalRecipes.results[num].id))
                        }
                    }
                    self.getmoreData()
                }
            } catch {
                print("JSON Decode error")
            }
        }
     
        // actually make the http task run.
        task.resume()
    
    }
    
    func getmoreData() {
        
        // 2. BEGIN NETWORKING code
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        //hard code 25 results at end
        let link: String = "https://api.spoonacular.com/recipes/informationBulk?ids=" + ids + "&apiKey=3779cda1cd174fa1b8677bd02ba7ba90"

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
        cell.recipeImage.load(url: urls!)

        cell.recipeLabel.text = totalRecipes.results[indexPath.row].title
        cell.waitTime = totalRecipes.results[indexPath.row].readyInMinutes
        cell.totalServings = totalRecipes.results[indexPath.row].servings
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! focusViewController
        let myRow = tableView!.indexPathForSelectedRow
        let myCurrCell = tableView.cellForRow(at: myRow!) as! recipesTableViewCell
        
        destVC.nameText = (myCurrCell.recipeLabel!.text)!
        destVC.waitNum = (myCurrCell.waitTime)
        destVC.servingsNum = (myCurrCell.totalServings)
        destVC.foodImage = (myCurrCell.recipeImage.image!)
        destVC.allInstructions = totalInstructions[myRow!.row].instructions
        
        var allingredients: String = ""
        for num in (0...totalInstructions[myRow!.row].extendedIngredients.count-2) {
            allingredients.append(totalInstructions[myRow!.row].extendedIngredients[num].originalString)
            allingredients.append("\n")
        }
        allingredients.append(totalInstructions[myRow!.row].extendedIngredients[totalInstructions[myRow!.row].extendedIngredients.count-1].originalString)
        destVC.ingredientsText = allingredients
        
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
