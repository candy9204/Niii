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
}