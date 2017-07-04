//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Kevin Cleathero on 2017-07-01.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties

    @IBOutlet var nameTextField: UITextField!
      
    @IBOutlet var photoImageView: UIImageView!

    @IBOutlet var ratingControl: RatingControl!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    @IBOutlet var calorieText: UITextField!
    
    @IBOutlet var descriptionTextView: UITextView!
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    //This declares a property on MealViewController that is an optional Meal, which means that at any point, it may be nil.
    var meal: Meal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self;
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        
        //If the meal property is non-nil, this code sets each of the views in MealViewController to display data from the meal property. The meal property will only be non-nil when an existing meal is being edited.
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }

        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    
//MARK: Navigation
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        //This code creates a Boolean value that indicates whether the view controller that presented this scene is of type UINavigationController
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        //The else block is called if the user is editing an existing meal
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
            
            //This else case executes only if the meal detail scene was not presented inside a modal navigation controller (for example, when adding a new meal), and if the meal detail scene was not pushed onto a navigation stack (for example, when editing a meal).
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        dismiss(animated: true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //The nil coalescing operator is used to return the value of an optional if the optional has a value, or return a default value otherwise. Here, the operator unwraps the optional String returned by nameTextField.text (which is optional because there may or may not be text in the text field), and returns that value if it’s a valid string. But if it’s nil, the operator the returns the empty string ("") instead.
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
//        
        guard let calorieText = calorieText.text,
            let caloriesCount = Int(calorieText) else{
          return
        }
    
        //or blank string  ?? = OR.  give ti a default value of emprty string
        let itemDescription = descriptionTextView.text ?? "some stuff here"
        
        let defaults = UserDefaults.standard
        let userId = defaults.value(forKey: "token") as! String
        
        //let userId = 92034582390485
        let Id = ""
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        //meal = Meal(name: name, photo: photo, rating: rating, calories: caloriesCount, itemDescription: itemDescription)
        //meal = Meal(name: name, photo: photo, rating: rating)
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        
        
        
        meal = Meal(name: name, photo: photo, rating: rating, calories: caloriesCount, itemDescription: itemDescription, userId: userId, Id: Id )
        let ct = CloudTrackerAPI()
        
        //question #1
        ct.saveMeal(meal: meal!, completion: { (nestedDict ) -> (Void) in
            //print(nestedDict)
            //print(nestedDict["id"] as Any)
            let ratingId = nestedDict["meal"]
            let id = ratingId?["id"]
            print(id!)
            
                // - key : id
                //- value : 126
            
            //save rating
        })

    }
    

//MARK: Actions
    
//    @IBAction func setDefaultLabelText(_ sender: UIButton) {
//        mealNameLabel.text = "Default Text"
//    }

    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //jide the keyboard
        //This code ensures that if the user taps the image view while typing in the text field, the keyboard is dismissed properly.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary //The type of imagePickerController.sourceType is known to be UIImagePickerControllerSourceType, which is an enumeration. This means you can write its value as the abbreviated form .photoLibrary instead of UIImagePickerControllerSourceType.photoLibrary.
        
        imagePickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        present(imagePickerController, animated: true, completion: nil)
        
    }

    
//MARK: UITextFieldDelegate
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    //You need to specify that the text field should resign its first-responder status when the user taps a button to end editing in the text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        //is called after the text field resigns its first-responder status.
        //The textFieldDidEndEditing(_:) method gives you a chance to read the information entered into the text field and do something with it
        
        //mealNameLabel.text = textField.text
        
        //The first line calls updateSaveButtonState() to check if the text field has text in it, which enables the Save button if it does. The second line sets the title of the scene to that text.
        updateSaveButtonState()
        navigationItem.title = textField.text
        
    }
    
    
//MARK: UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        //The first of these, imagePickerControllerDidCancel(_:), gets called when a user taps the image picker’s Cancel button. This method gives you a chance to dismiss the UIImagePickerController (and optionally, do any necessary cleanup).
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        //The info dictionary always contains the original image that was selected in the picker.
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as?
        UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
//MARK: Private Methods
    //This is a helper method to disable the Save button if the text field is empty.
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}





