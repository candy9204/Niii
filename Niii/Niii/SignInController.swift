//
//  SignInController.swift
//  Niii
//
//  Created by LinShengyi on 4/15/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initAppearance()
        
        self.loginView.layer.cornerRadius = self.loginView.frame.size.width / 8
        self.loginView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(sender: AnyObject) {
        if(!username.text.isEmpty && !password.text.isEmpty) {
            if(username.text == "asdf" && password.text == "asdf"){
                
                let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
                self.presentViewController(mainPage, animated:true, completion:nil)
            } else {
                let alertController = UIAlertController(title: "Sign In Failed", message:
                    "The username or the password is incorrect!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Sign In Failed", message:
                "The username and the password cannot be empty!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    
    func initAppearance() -> Void {
        let background = CAGradientLayer().blueColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
}
