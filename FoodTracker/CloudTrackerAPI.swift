//
//  CloudTrackerAPI.swift
//  FoodTracker
//
//  Created by Kevin Cleathero on 2017-07-03.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import Foundation

class CloudTrackerAPI: NSObject{
    
    //POST - /users/me/meals
   
    //func getMeal(meal: Meal, completion: @escaping ([String:[String:Any]])->(Void)){
    
    //question #2
    func getMeal(completion: @escaping ([[String:Any]])->(Void)){
        // let upload = meal
        let mealreq = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/users/me/meals/")!)
        //let postData = ["title":meal.name, "calories":meal.calories,"description":meal.itemDescription] as [String: Any]
        
//        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: [])else{
//            print("could not serialize JSON")
//            return
//        }

        //mealreq.httpBody = postJSON
        mealreq.httpMethod = "GET"
        
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "token") as! String
        
        mealreq.addValue(token, forHTTPHeaderField: "token")
        mealreq.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let task = URLSession.shared.dataTask(with: mealreq as URLRequest) { (data, resp, err) in
            
            guard data != nil else {
                print("no data returned from server \(String(describing: err))")
                return
            }
            
            guard let resp = resp as? HTTPURLResponse else {
                print("no response returned from server \(String(describing: err))")
                return
            }
            
            guard let rawJSON = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                
                print("data returned is not json, or not valid")
                return
            }
            
            guard resp.statusCode == 200 else {
                // handle error
                print("an error occurred")
                return
            }
            print(rawJSON)
            completion(rawJSON as! [[String:Any]])
            
        }
        
        task.resume()
    }

    ////////////////////
    
    func saveMeal(meal: Meal, completion: @escaping ([String:[String:Any]])->(Void)){
           // let upload = meal
            let mealreq = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/users/me/meals/")!)
            let postData = ["title":meal.name, "calories":meal.calories,"description":meal.itemDescription] as [String: Any]
            
            guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: [])else{
                print("could not serialize JSON")
                return
            }
        
            mealreq.httpBody = postJSON
            mealreq.httpMethod = "POST"
            
            let defaults = UserDefaults.standard
            let token = defaults.value(forKey: "token") as! String
            
            mealreq.addValue(token, forHTTPHeaderField: "token")
            mealreq.addValue("application/json", forHTTPHeaderField: "Content-type")
        
    
            let task = URLSession.shared.dataTask(with: mealreq as URLRequest) { (data, resp, err) in
    
                guard data != nil else {
                    print("no data returned from server \(String(describing: err))")
                    return
                }
    
                guard let resp = resp as? HTTPURLResponse else {
                    print("no response returned from server \(String(describing: err))")
                    return
                }
                
                guard let rawJSON = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                    
                    print("data returned is not json, or not valid")
                    return
                }

                guard resp.statusCode == 200 else {
                    // handle error
                    print("an error occurred")
                    return
                }
                
                completion(rawJSON as! [String:[String:Any]])
                DispatchQueue.main.async {
                    completion(rawJSON as! [String:[String:Any]])
                }
                
                
            }
            
            task.resume()
        }
    
    

//    func login(data: [String: AnyObject], toEndpoint: String, completion: @escaping (Data?, NSError?)->(Void)){
//        
//        guard let postJSON = try? JSONSerialization.data(withJSONObject: Data(), options: []) else {
//            
//            print("could not serialize json")
//            return
//        }
//        
//        let req = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/login")!)
//        
//        req.httpBody = postJSON
//        req.httpMethod = "POST"
//        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let task = URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, err) in
//            
//            guard let data = data else {
//                
//                print("no data returned from server \(String(describing: err))")
//                return
//            }
//            
//            guard let resp = resp as? HTTPURLResponse else {
//                
//                print("no response returned from server \(String(describing: err))")
//                return
//            }
//            
//            guard let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:[String:String]] else {
//                
//                print("data returned is not json, or not valid")
//                return
//            }
//            
//            guard resp.statusCode == 200 else {
//                
//                //Handle error here...
//                print("an error occurred")
//                return
//            }
//            
//            //return rawJSON
////            //Do something here with the data returned (decode json, save to user defaults, etc.)
////            let defaults = UserDefaults.standard
////            defaults.set(userName, forKey: "username")
////            defaults.set(password, forKey: "password")
////            defaults.set(rawJSON["user"], forKey: "user")
////            self.dismiss(animated: true, completion: nil)
//        }
//        
//        task.resume()
//
//    }
    
    
    func post(data: [String: AnyObject], toEndpoint: String, completion: @escaping (Data?, NSError?)->(Void)){
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            print("could not serialize json")
            return
        }
        print(postJSON)
        let string = toEndpoint
        let req = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/\(string)")!)
        print("http://159.203.243.24:8000/\(string)")
        req.httpBody = postJSON
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, err) in
            
            guard let data = data else {
                print("no data returned from server \(String(describing: err))")
                return
            }
            
            guard let resp = resp as? HTTPURLResponse else {
                print("no response returned from server \(String(describing: err))")
                return
            }
            
            //guard for this
            //guard convert to unless statuscode is == 200
            guard resp.statusCode == 200 else {
                // handle error
                print("an error occurred")
                return
            }
            
            completion(data,err as NSError?)
            
        }
        
        task.resume()
    }
}
