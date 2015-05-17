//
//  SingleEventController.swift
//  Niii
//
//  Created by LinShengyi on 4/30/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class SingleEventController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.navigationController!.setNavigationBarHidden(false, animated:true)
//        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom)as! UIButton
//        myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
//        myBackButton.setTitle("YOUR TITLE", forState: UIControlState.Normal)
//        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
//        myBackButton.sizeToFit()
//        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
//        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    
    @IBAction func BackToEvents(sender: AnyObject) {
        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
        self.presentViewController(mainPage, animated:true, completion:nil)
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        return cell;
    }
}