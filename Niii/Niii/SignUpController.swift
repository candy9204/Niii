//
//  SignUpController.swift
//  Niii
//
//  Created by LinShengyi on 5/19/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var nickname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initAppearance()
        
        self.signUpView.layer.cornerRadius = self.signUpView.frame.size.width / 16
        self.signUpView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("signInPage") as! UIViewController
        signInPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(signInPage, animated:true, completion:nil)
    }
    
    @IBAction func submit(sender: AnyObject) {

        if(username.text.isEmpty || password.text.isEmpty || confirm.text.isEmpty){
            // If no username or password, prompt error
            let alertController = UIAlertController(title: "Sign Up Failed", message:
                "The username, the password and the confirmed password cannot be empty!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if(password.text != confirm.text){
            // If password is different from confirmed password, prompt error
            let alertController = UIAlertController(title: "Sign Up Failed", message:
                "The password and the confirmed password do not match!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else{
            // TODO: Submit Sign Up Information
            //       username.text to access Username
            //       password.text to access Password
            //       confirm.text to access Confirm
            //       sex.text to access Sex
            //       age.text to access Age
            
            // If the username is exist, prompt error
            
            if password.text != confirm.text {
                let alertController = UIAlertController(title: "Sign Up Failed", message:
                    "Confirm does not match with your password", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            } else {
                register()
            }
        }
        
    }
    
    func register() {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8000/user/register/")!)
        request.HTTPMethod = "POST"
        let postString = "username=" + username.text + "&password=" + password.text
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
                return
            }
            
            if let success = jsonResult["success"] as? Int {
                dispatch_async(dispatch_get_main_queue(), {
                    if success == 0 {
                        
                        let msg = jsonResult["message"] as? String
                        let alertController = UIAlertController(title: "Sign Up Failed", message:
                            msg, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        let id = jsonResult["id"] as! Int
                        User.UID = String(id)
                        self.update()
                        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
                        self.presentViewController(mainPage, animated:true, completion:nil)
                    }
                })
            }
            
        }
        task.resume()
    }
    
    func update(){
        var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8000/user/" + User.UID + "/profile/update/")!)
        request.HTTPMethod = "POST"
        let postString = "gender=" + sex.text + "&nickname=" + nickname.text
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if (err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                return
            }
            
            println(jsonResult)
            
            User.nickname = self.nickname.text
            User.gender = self.sex.text
            
        }
        task.resume()
    }

    
}