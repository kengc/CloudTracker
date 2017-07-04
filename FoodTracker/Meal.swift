//
//  Meal.swift
//  FoodTracker
//
//  Created by Kevin Cleathero on 2017-07-02.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import os.log

//class Meal: NSObject, NSCoding {
//    
//    //In Swift, you can represent the name using a String, the photo using a UIImage, and the rating using an Int. Because a meal always has a name and rating but might not have a photo, make the UIImage an optional.
////MARK: Peroperties
//    var name: String
//    var photo: UIImage?
//    var rating: Int
//
//    
//    //You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class. Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
//    
////MARK: Types
//    
//    struct PropertyKey {
//        //Each constant corresponds to one of the three properties of Meal
//        static let name = "name"
//        static let photo = "photo"
//        static let rating = "rating"
//    }
//    
////MARK: Initialization
//    
//    //your initializer returns an optional Meal? object. in case one of the params sent is nil, then return a nil object
//    init?(name: String, photo: UIImage?, rating: Int) {
//        
//        
//        //A guard statement declares a condition that must be true in order for the code after the guard statement to be executed. If the condition is false, the guard statement’s else branch must exit the current code block (for example, by calling return, break, continue, throw, or a method that doesn’t return like fatalError(_:file:line:)).
//        // The name must not be empty
//        guard !name.isEmpty else {
//            return nil
//        }
//
//            // The rating must be between 0 and 5 inclusively
//        guard (rating >= 0) && (rating <= 5) else {
//            return nil
//        }
//        // Initialize stored properties.
//        self.name = name
//        self.photo = photo
//        self.rating = rating
//
//    }
//    
////MARK: NSCoding
//    func encode(with aCoder: NSCoder) {
//        //Each method encodes data of the given type. In the code shown above, the first two lines pass a String argument, while the third line passes an Int. These lines encode the value of each property on the Meal class and store them with their corresponding key.
//        aCoder.encode(name, forKey: PropertyKey.name)
//        aCoder.encode(photo, forKey: PropertyKey.photo)
//        aCoder.encode(rating, forKey: PropertyKey.rating)
//
//    }
//    
//    //The required modifier means this initializer must be implemented on every subclass, if the subclass defines its own initializers.
//    //The convenience modifier means that this is a secondary initializer, and that it must call a designated initializer from the same class.
//    //The question mark (?) means that this is a failable initializer that might return nil.
//    required convenience init?(coder aDecoder: NSCoder) {
//        // The name is required. If we cannot decode a name string, the initializer should fail.
//        //The decodeObject(forKey:) method decodes encoded information.
//        //The return value of decodeObjectForKey(_:) is an Any? optional. The guard statement both unwraps the optional and downcasts the enclosed type to a String, before assigning it to the name constant. If either of these operations fail, the entire initializer fails.
//        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
//            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        // Because photo is an optional property of Meal, just use conditional cast.
//        //You downcast the value returned by decodeObject(forKey:) as a UIImage, and assign it to the photo constant. If the downcast fails, it assigns nil to the photo property. There is no need for a guard statement here, because the photo property is itself an optional.
//        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
//        
//        //The decodeIntegerForKey(_:) method unarchives an integer. Because the return value of decodeIntegerForKey is Int, there’s no need to downcast the decoded value and there is no optional to unwrap.
//        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
//        
//
//        
//        // Must call designated initializer.
//        //As a convenience initializer, this initializer is required to call one of its class’s designated initializers before completing.
//        self.init(name: name, photo: photo, rating: rating)
//    }
//    
//}

///////

class Meal: NSObject, NSCoding {
    
    //In Swift, you can represent the name using a String, the photo using a UIImage, and the rating using an Int. Because a meal always has a name and rating but might not have a photo, make the UIImage an optional.
    //MARK: Peroperties
    var name: String
    var photo: UIImage?
    var rating: Int
    var calories: Int
    var itemDescription: String
    var userId: String
    var Id: String
    
    //You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class. Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    
    struct PropertyKey {
        //Each constant corresponds to one of the three properties of Meal
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let calories = "calories"
        static let itemDescription = "itemDescription"
        static let userId = "userId"
        static let Id = "Id"
        
    }
    
    //MARK: Initialization
    
    //your initializer returns an optional Meal? object. in case one of the params sent is nil, then return a nil object
    init?(name: String, photo: UIImage?, rating: Int, calories: Int, itemDescription: String, userId: String, Id: String) {
        
        
        //A guard statement declares a condition that must be true in order for the code after the guard statement to be executed. If the condition is false, the guard statement’s else branch must exit the current code block (for example, by calling return, break, continue, throw, or a method that doesn’t return like fatalError(_:file:line:)).
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        guard !itemDescription.isEmpty else {
            return nil
        }
        
        guard calories > 0 else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.calories = calories
        self.itemDescription = itemDescription
        self.userId = userId
        self.Id = Id
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        //Each method encodes data of the given type. In the code shown above, the first two lines pass a String argument, while the third line passes an Int. These lines encode the value of each property on the Meal class and store them with their corresponding key.
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(calories, forKey: PropertyKey.calories)
        aCoder.encode(itemDescription, forKey: PropertyKey.itemDescription)
        aCoder.encode(userId, forKey: PropertyKey.userId)
        aCoder.encode(Id, forKey: PropertyKey.Id)
    }
    
    //The required modifier means this initializer must be implemented on every subclass, if the subclass defines its own initializers.
    //The convenience modifier means that this is a secondary initializer, and that it must call a designated initializer from the same class.
    //The question mark (?) means that this is a failable initializer that might return nil.
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        //The decodeObject(forKey:) method decodes encoded information.
        //The return value of decodeObjectForKey(_:) is an Any? optional. The guard statement both unwraps the optional and downcasts the enclosed type to a String, before assigning it to the name constant. If either of these operations fail, the entire initializer fails.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is an optional property of Meal, just use conditional cast.
        //You downcast the value returned by decodeObject(forKey:) as a UIImage, and assign it to the photo constant. If the downcast fails, it assigns nil to the photo property. There is no need for a guard statement here, because the photo property is itself an optional.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //The decodeIntegerForKey(_:) method unarchives an integer. Because the return value of decodeIntegerForKey is Int, there’s no need to downcast the decoded value and there is no optional to unwrap.
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        let calories = aDecoder.decodeInteger(forKey: PropertyKey.calories)
        
        guard let itemDescription = aDecoder.decodeObject(forKey: PropertyKey.itemDescription) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let  userId = aDecoder.decodeObject(forKey: PropertyKey.userId) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }

        
        guard let  Id = aDecoder.decodeObject(forKey: PropertyKey.Id)as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }

        
        // Must call designated initializer.
        //As a convenience initializer, this initializer is required to call one of its class’s designated initializers before completing.
        self.init(name: name, photo: photo, rating: rating, calories: calories, itemDescription: itemDescription, userId: userId, Id:Id)
    }
    
}

