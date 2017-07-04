//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Kevin Cleathero on 2017-07-02.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {

//MARK: Properties
    
    //an array of meal objects: var = mutable
    var meals = [Meal]()
    
    @IBOutlet var mealTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        //in otherwords ADD an edit (delete) button to the top left navi bar
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        // Load any saved meals, otherwise load sample data.
        //If loadMeals() successfully returns an array of Meal objects, this condition is true and the if statement gets executed. If loadMeals() returns nil, there were no meals to load and the if statement doesn’t get executed. This code adds any meals that were successfully loaded to the meals array.
        
        loadShit()
        
//        let ct = CloudTrackerAPI()
//        
//        //        guard let upload = meal else {
//        //            return
//        //        }
//        //question #1
//        
//        ct.getMeal(completion: { (meals ) -> (Void) in
// 
//            //it was an array of dictionaries
//            for meal in meals{
//                guard let meal = Meal(name: meal["title"] as! String,
//                                      photo: meal["imagePath"] as? UIImage,
//                                      rating: meal["rating"] as! Int,
//                                      calories:meal["calories"] as! Int,
//                                      itemDescription: meal["description"] as! String,
//                                      userId: "",
//                                      Id:String(meal["id"] as! Int)) else {
//                    fatalError("Unable to instantiate meal1")
//                }
//                self.meals += [meal]
//            }
//            
//        })

        //old way of loading
//        if let savedMeals = loadMeals() {
//            meals += savedMeals
//        }
//        else {
//            // Load the sample data.
//            loadSampleMeals()
//        }
        
        
        
        // Load the sample data.
        //loadSampleMeals()

    }


     func loadShit() {
        
        let ct = CloudTrackerAPI()
        
        ct.getMeal(completion: { (meals) -> (Void) in
            
            //it was an array of dictionaries
            for meal in meals{
                guard let meal = Meal(name: meal["title"] as! String,
                                      photo: meal["imagePath"] as? UIImage,
                                      rating: meal["rating"] as! Int,
                                      calories:meal["calories"] as! Int,
                                      itemDescription: meal["description"] as! String,
                                      userId: "",
                                      Id:String(meal["id"] as! Int)) else {
                                        fatalError("Unable to instantiate meal1")
                }
                self.meals += [meal]
            }
          //self.mealTable.reloadData()
        self.mealTable.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: true)
        })
        
    }
    
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(meals.count)
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MealTableViewCell"
        
        
        //The guard let expression safely unwraps the optional.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? MealTableViewCell else{
                
           //The as? MealTableViewCell expression attempts to downcast the returned object from the UITableViewCell class to your MealTableViewCell class. This returns an optional.
           fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }

        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        // Configure the cell...
        return cell
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //This code removes the Meal object to be deleted from meals. The line after it, which is part of the template implementation, deletes the corresponding row from the table view.
            meals.remove(at: indexPath.row)
    
            //This code saves the meals array whenever a meal is deleted.
            saveMeals()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        

    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
            
        return true
    }
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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


// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        //The code below examines the segue’s identifier. If the identifier is nil, the nil-coalescing operator (??) replaces it with an empty string (""). This simplifies the switch statement’s logic, since you won’t need to deal with optionals inside the cases.
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
   }
 
    
//MARK: Actions
    
    
    //IBAction makes this function visible in the iterface builder as a method option for drag and drop etc
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        
        //This code uses the optional type cast operator (as?) to try to downcast the segue’s source view controller to a MealViewController instance. You need to downcast because sender.sourceViewController is of type UIViewController, but you need to work with a MealViewController.
        //The operator returns an optional value, which will be nil if the downcast wasn’t possible. If the downcast succeeds, the code assigns the MealViewController instance to the local constant sourceViewController, and checks to see if the meal property on sourceViewController is nil. If the meal property is non-nil, the code assigns the value of that property to the local constant meal and executes the if statement.
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            // Add a new meal.
            
            
            //This code checks whether a row in the table view is selected. If it is, that means a user tapped one of the table views cells to edit a meal. In other words, this if statement gets executed when you are editing an existing meal.
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing meal.  It replaces the old meal object with the new, edited meal object.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
                
                //The else clause executes when there’s no selected row in the table view, which means a user tapped the Add button to get to the meal detail scene. In other words, this else statement executes when the user adds a new meal.
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the meals.
            //This code saves the meals array whenever a new one is added or an existing one is updated.
            saveMeals()
        }
    }
    
    
//MARK: Private Methods
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        
        //Because the Meal class’s init!(name:, photo:, rating:) initializer is failable, you need to check the result returned by the initializer.
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4, calories: 100, itemDescription: "blahblahblah", userId: "93204852345", Id:"9840239485234") else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5, calories: 100, itemDescription: "blahblahblah", userId: "93204852345", Id:"9840239485234") else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3, calories: 100, itemDescription: "blahblahblah", userId: "93204852345", Id:"9840239485234") else {
            fatalError("Unable to instantiate meal2")
        }
        
//        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
//            fatalError("Unable to instantiate meal1")
//        }
//        
//        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
//            fatalError("Unable to instantiate meal2")
//        }
//        
//        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
//            fatalError("Unable to instantiate meal2")
//        }
        
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals() {
        //This method attempts to archive the meals array to a specific location, and returns true if it’s successful. It uses the constant Meal.ArchiveURL that you defined in the Meal class to identify where to save the information.
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        
        //This method attempts to unarchive the object stored at the path Meal.ArchiveURL.path and downcast that object to an array of Meal objects. This code uses the as? operator so that it can return nil if the downcast fails. This failure typically happens because an array has not yet been saved. In this case, the unarchiveObject(withFile:) method returns nil. The attempt to downcast nil to [Meal] also fails, itself returning nil.
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
}







