//
//  SingleFriendController.swift
//  Niii
//
//  Created by LinShengyi on 5/19/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class SingleFriendController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentController = 0
    var parentTab = 0
    var cells:[UITableViewCell] = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func backToFriends(sender: AnyObject) {
        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
        mainPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        mainPage.selectedIndex = parentController;
        let friendsController = mainPage.selectedViewController as! FriendsController
        friendsController.followingList.hidden = (parentTab == 1)
        friendsController.followersList.hidden = (parentTab == 0)
        friendsController.controller.selectedSegmentIndex = parentTab
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
        // Number of cells
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        // Initialize cell
        // indexPath.row #
        
        return cell;
    }
}