//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Kevin Cleathero on 2017-07-01.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import XCTest

//Note that the code uses the @testable attribute when importing your app. This gives your tests access to the internal elements of your app’s code. Remember, Swift defaults to internal access control for all the types, variables, properties, initializers, and functions in your code. If you haven’t explicitly marked an item as file private or private, you can access it from your tests.
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
//MARK: Meal Class Tests
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Highest positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testMealInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        // Empty String
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
    
}
