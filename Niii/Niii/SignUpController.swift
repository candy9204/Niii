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
    @IBOutlet weak var age: UITextField!
    
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
            
            // Else go to main page
            let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
            mainPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.presentViewController(mainPage, animated:true, completion:nil)
        }
        
    }
    
}