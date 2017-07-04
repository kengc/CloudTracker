//
//  SignupViewController.swift
//  FoodTracker
//
//  Created by Kevin Cleathero on 2017-07-03.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit


class SignupViewController: UIViewController, UITextFieldDelegate {

    
//MARK - Properties
    @IBOutlet var userNameText: UITextField!

    @IBOutlet var passwordText: UITextField!
    
    @IBOutlet var logMessageLabel: UILabel!

    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var actionTypeLabel: UILabel!
    
    var isNewUser: Bool = true
    var validCredentials: Bool = true

    
//MARK - standard overrides
    
    
    override func viewDidLoad() {
       
         super.viewDidLoad()
        
        logMessageLabel.isHidden = true
        
        // Load any saved meals, otherwise load sample data.
        
        let defaults = UserDefaults.standard
        //defaults.removeObject(forKey:"user")
        //kevin
        //password
        
        //if let _ = defaults.dictionary(forKey: "user") {
        
        
        //if defaults.dictionary(forKey: "user") == nil {
        //print(defaults.dictionary(forKey: "user") ?? <#default value#>)
        if let _ = defaults.dictionary(forKey: "user") {
            isNewUser = false
            LoginExistingUser()
        } else { //did not get anything from dictionary, hence a new user
            isNewUser = true
            SignUpNewUser()
        }
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {

//    }

//MARK - Signup New user or Log in
    func SignUpNewUser() {
        //do sign up shit
        actionTypeLabel.text = "Sign Up"
        logMessageLabel.isHidden = false
        logMessageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        logMessageLabel.numberOfLines = 2
        logMessageLabel.text = "Please enter a valid username and password (minimum 6 characters)"
        
    }
    
    func LoginExistingUser() {
        //do sign up shit
        actionTypeLabel.text = "Login"
    }
    
//MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
//MARK - Action
    @IBAction func submitAction(_ sender: UIButton) {
        if(isNewUser){
            submitNewUser()
        } else {
            submitExistingUser()
        }
    }

    func submitExistingUser() {
        guard let userName = userNameText.text else{
            self.logMessageLabel.isHidden = false
            return
        }
        
        guard let password = passwordText.text, (passwordText.text?.characters.count)! > 5 else{
            self.logMessageLabel.isHidden = false
            return
        }
        
        print(userName)
        print(password)
        
        let postData = [
            "username": userName,
            "password": password
        ]

        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            
            print("could not serialize json")
            return
        }
        
        let req = NSMutableURLRequest(url: URL(string:"http://159.203.243.24:8000/login")!)
        
        req.httpBody = postJSON
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: req as URLRequest) { (data, resp, err) in
            
            guard let data = data else {
                
                print("no data returned from server \(String(describing: err))")
                return
            }
            
            //guard let resp = resp as? HTTPURLResponse else {
            guard (resp as? HTTPURLResponse) != nil else {
                print("no response returned from server \(String(describing: err))")
                return
            }
            
            guard let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any] else {
                
                print("data returned is not json, or not valid")
                return
            }
            
            print(rawJSON)
            let user = rawJSON["user"]
            print(user ?? "")

//
//            guard resp.statusCode == 200 else {
//                
//                //Handle error here...
//                print("an error occurred")
//                return
//            }
            
            //Do something here with the data returned (decode json, save to user defaults, etc.)
            if let _ = rawJSON["error"]  {
                     self.validCredentials = false
                } else {
         
                let defaults = UserDefaults.standard
                defaults.set(userName, forKey: "username")
                defaults.set(password, forKey: "password")
                defaults.set(rawJSON["user"], forKey: "user")
                
                
                //fetch token
                let user = rawJSON["user"] as! [String:Any]
                let token = user["token"] as! String
                
                print(token)
                defaults.set(token, forKey: "token")
                
                
                let tokenz = defaults.value(forKey: "token") as! String
                print(tokenz)
                self.validCredentials = true
        
            }
            
            DispatchQueue.main.async {
                if(self.validCredentials){
                    self.performSegue(withIdentifier: "showApp", sender: nil)
                }else{
                    let alert = UIAlertController(title: "Alert", message: "Invalid User name or Password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        
           }
        }
        task.resume()
}


    
    func submitNewUser(){
        //guarding against username not being nil
        //anything in the else is nil
        //guarding against the cae that userNameText.text being nil
        // use _ if you are not using avariable
        guard let userName = userNameText.text else{
            logMessageLabel.isHidden = false
            return
        }
        
        guard let password = passwordText.text, (passwordText.text?.characters.count)! > 5 else{
            logMessageLabel.isHidden = false
            return
        }
        
        print(userName)
        print(password)
        
        let postData = [
            "username": userName,
            "password": password
        ]
        
        let defaults = UserDefaults.standard
        let cloudTracker = CloudTrackerAPI()
        
        
        cloudTracker.post(data: postData as [String : AnyObject], toEndpoint: "signup", completion: {
            
            (completion:(data: Data?, error: NSError?)) in
            guard let rawJSON = try? JSONSerialization.jsonObject(with: completion.data!, options: []) as! [String:[String:String]] else {
                
                print("data returned is not json, or not valid")
                return
            }
            
            defaults.set(rawJSON["user"], forKey: "user")
            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "showApp", sender: nil)
        })
    }

}



