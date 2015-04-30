//
//  FriendsController.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var controller: UISegmentedControl!
    @IBOutlet weak var chatList: UITableView!
    @IBOutlet weak var friendsList: UITableView!
    var friends = [String]()
    var chat = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.friendsList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.chatList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.chatList.hidden = false
        self.friendsList.hidden = true
        self.friends = ["Li Ding", "Yilin Xiong", "Mengdi Zhang", "Di Li"]
        self.chat = ["Yilin Xiong", "Li Ding"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.friendsList){
            return self.friends.count;
        } else{
            return self.chat.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.friendsList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        if(tableView == self.friendsList){
            cell.textLabel?.text = self.friends[indexPath.row]
            cell.imageView?.image = UIImage(named: "me.png")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else{
            cell.textLabel?.text = self.chat[indexPath.row]
            cell.imageView?.image = UIImage(named: "me.png")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
    
        return cell
    }
    
    @IBAction func controllerIndexChanged(sender: UISegmentedControl) {
        switch self.controller.selectedSegmentIndex {
            case 0:
                self.chatList.hidden = false
                self.friendsList.hidden = true
            case 1:
                self.chatList.hidden = true
                self.friendsList.hidden = false
            default:
                break;
        }
    }
}
