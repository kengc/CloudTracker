//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Kevin Cleathero on 2017-07-02.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

//Interface Builder does not know anything about the contents of your rating control. To fix this, you define the control as @IBDesignable. 
@IBDesignable class RatingControl: UIStackView {
    
//MARK: Properties
    
    //array of buttons
    private var ratingButtons = [UIButton]()
    
    //By leaving it as internal access (the default), you can access it from any other class inside the app.
    //have it call the updateButtonSelectionStates() method whenever the rating changes.
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    //These lines define the size of your buttons and the number of buttons in your control.
    //make them available in inspector set them to @IBInspectable
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        // you define property observers
        //A property observer observes and responds to changes in a property’s value. Property observers are called every time a property’s value is set, and can be used to perform work immediately before or after the value changes.
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5{
        // you define property observers
        //A property observer observes and responds to changes in a property’s value. Property observers are called every time a property’s value is set, and can be used to perform work immediately before or after the value changes.
        didSet{
            setupButtons()
        }
        
    }
    
    

//MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    
    //Swift handles initializers differently than other methods. If you don’t provide any initializers, Swift classes automatically inherit all of their super class’s designated initializers. If you implement any initializers, you not longer inherit any of the superclasses initializers; however, the superclass can mark one or more of its initializers as required. The subclass must implement (or automatically inherit) all of the required initializers. Furthermore, the subclass must mark their initializers as required, indicating that their subclasses must also implement the initializers.
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
        //fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: Button Action
    
    func ratingButtonTapped(button: UIButton) {
        //print("Button pressed 👍")
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    
//MARK: Private Methods
    private func setupButtons() {
        
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        
        // Load Button Images
        //Buttons have five different states: normal, highlighted, focused, selected, and disabled. By default, the button modifies its appearance based on its state, for example a disabled button appears grayed out. A button can be in more than one state at the same time, such as when a button is both disabled and highlighted.
        //Buttons always start in the normal state (not highlighted, selected, focused, or disabled)
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        for index in 0..<starCount {
            
            // Create the button
            let button = UIButton()
            //button.backgroundColor = UIColor.red
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            //The first line of code disables the button’s automatically generated constraints.
            //Together, these lines define the button as a fixed-size object in your layout (44 point x 44 point).
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            //n the previous lesson, you used the target-action pattern to link elements in your storyboard to action methods in your code. The addTarget(_, action:, for:) method does the same thing in code. You’re attaching the ratingButtonTapped(_:) action method to the button object, which will be triggered whenever the .TouchDown event occurs.
            // - The target is self, which refers to the current instance of the enclosing class. In this case, it refers to the RatingControl object that is setting up the buttons.
            
            // - action: #selector(RatingControl.ratingButtonTapped(button:) is a method call to the ratingButtonTapped actin above
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        //You also need to update the button’s selection state whenever buttons are added to the control.
        updateButtonSelectionStates()
    }

    private func updateButtonSelectionStates() {
        //This code iterates through the buttons and sets each one’s selected state based on its position and the rating.
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}













