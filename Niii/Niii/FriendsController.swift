//
//  FriendsController.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var controller: UISegmentedControl!
    @IBOutlet weak var chatList: UITableView!
    @IBOutlet weak var friendsList: UITableView!
    var friends = [String]()
    var chat = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.friendsList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.friendsList.rowHeight = 50.0
        self.chatList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.chatList.rowHeight = 50.0
        self.chatList.hidden = false
        self.friendsList.hidden = true
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColorFromHex.color(0x0075FF).CGColor
        self.searchBar.layer.backgroundColor = UIColorFromHex.color(0x0075FF).CGColor
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
        var subView:UIView!
        
        if(tableView == self.friendsList){
            let th = self.friendsList.rowHeight;
            let tw = self.friendsList.bounds.width;
            
            // Subview
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(0, 3.0)
            subView.layer.shadowOpacity = 0.2
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            // Image
            let imageName = "me.png"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
            subView.addSubview(imageView)
            
            // label
            let label = UILabel();
            label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: sh-10)
            label.text = self.friends[indexPath.row]
            subView.addSubview(label)
            
            // Cell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.backgroundColor = UIColor.clearColor();
            cell.contentView.addSubview(subView)
            
        } else{
            let th = self.chatList.rowHeight;
            let tw = self.chatList.bounds.width;
            
            // Subview
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(0, 3.0)
            subView.layer.shadowOpacity = 0.2
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            // Image
            let imageName = "me.png"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
            subView.addSubview(imageView)
            
            // label
            let label = UILabel();
            label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: sh-10)
            label.text = self.chat[indexPath.row]
            subView.addSubview(label)
            
            // Cell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.backgroundColor = UIColor.clearColor();
            cell.contentView.addSubview(subView)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if(tableView == self.friendsList){
            let singleFriend = self.storyboard?.instantiateViewControllerWithIdentifier("singleFriendPage") as! SingleFriendController
            singleFriend.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            singleFriend.parentController = 2
            self.presentViewController(singleFriend, animated:true, completion:nil)
        }
        else{
            let chat = self.storyboard?.instantiateViewControllerWithIdentifier("chatPage") as! ChatController
            chat.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            chat.parentController = 2
            self.presentViewController(chat, animated:true, completion:nil)
        }
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
}
