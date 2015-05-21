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
    @IBOutlet weak var followingList: UITableView!
    @IBOutlet weak var followersList: UITableView!
    var followers = [FriendProfile]()
    var cells_followers:[UITableViewCell] = [UITableViewCell]()
    var following = [FriendProfile]()
    var cells_following:[UITableViewCell] = [UITableViewCell]()
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.followersList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.followersList.rowHeight = 50.0
        self.followingList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.followingList.rowHeight = 50.0
        self.followingList.hidden = false
        self.followersList.hidden = true
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColorFromHex.color(0x0075FF).CGColor
        self.searchBar.layer.backgroundColor = UIColorFromHex.color(0x0075FF).CGColor
        
        loadFriends()
        createCells()
    }
    
    func createCells(){
        for var i = 0; i < self.followers.count; i++ {
            var cell:UITableViewCell = self.followersList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            var subView:UIView!
            
            let tw = self.bounds.width;
            
            let th = self.followersList.rowHeight
            
            // Subview
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            // Image
            let imageView = UIImageView(image: followers[i].image)
            imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
            subView.addSubview(imageView)
            
            // label
            let label = UILabel();
            label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: sh-10)
            label.text = self.followers[i].nickName
            subView.addSubview(label)
            
            // Cell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.backgroundColor = UIColor.clearColor();
            cell.contentView.addSubview(subView)
            
            cells_followers.append(cell)
        }
        for var i = 0; i < self.following.count; i++ {
            var cell:UITableViewCell = self.followersList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            var subView:UIView!
            
            let tw = self.bounds.width;
            let th = self.followingList.rowHeight
            
            // Subview
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            // Image
            let imageView = UIImageView(image: following[i].image)
            imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
            subView.addSubview(imageView)
            
            // label
            let label = UILabel();
            label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: sh-10)
            label.text = self.following[i].nickName
            subView.addSubview(label)
            
            // Cell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.backgroundColor = UIColor.clearColor();
            cell.contentView.addSubview(subView)
            
            cells_following.append(cell)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFriends(){
        // TODO: Load the information of friends from database
        let imageName = "me.png"
        // Followers
        self.followers.append(FriendProfile(userName: "HAHA", nickName: "XIXI", rating: 4, email: "asdf@df.com", numberOfFollowers: 5, numberOfFollowing: 6, gender: 1, image: UIImage(named: imageName)!, updated: true))
        self.followers.append(FriendProfile(userName: "AO", nickName: "AI", rating: 4, email: "asdf@ds.com", numberOfFollowers: 5, numberOfFollowing: 6, gender: 1, image: UIImage(named: imageName)!, updated: true))
        self.followers.append(FriendProfile(userName: "DO", nickName: "AQ", rating: 4, email: "aasdf@ds.com", numberOfFollowers: 5, numberOfFollowing: 6, gender: 1, image: UIImage(named: imageName)!, updated: true))
        // Following
        self.following.append(FriendProfile(userName: "AO", nickName: "AI", rating: 4, email: "asdf@ds.com", numberOfFollowers: 5, numberOfFollowing: 6, gender: 1, image: UIImage(named: imageName)!, updated: true))
        self.following.append(FriendProfile(userName: "DO", nickName: "AQ", rating: 4, email: "aasdf@ds.com", numberOfFollowers: 5, numberOfFollowing: 6, gender: 1, image: UIImage(named: imageName)!, updated: true))
        self.following.append(FriendProfile(userName: "HAHA", nickName: "XIXI", rating: 4, email: "asdf@df.com", numberOfFollowers: 5, numberOfFollowing: 6, gender: 1, image: UIImage(named: imageName)!, updated: true))
        self.following.append(FriendProfile(userName: "HAASDFHA", nickName: "XASDFI", rating: 4, email: "asdf@df.com", numberOfFollowers: 5, numberOfFollowing: 5, gender: 1, image: UIImage(named: imageName)!, updated: true))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  tableView == self.followersList {
            return self.followers.count;
        } else {
            return self.following.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.followersList {
            return cells_followers[indexPath.row]
        } else {
            return cells_following[indexPath.row]
        }
    }
    
    @IBAction func controllerIndexChanged(sender: UISegmentedControl) {
        switch self.controller.selectedSegmentIndex {
            case 0:
                self.followingList.hidden = false
                self.followersList.hidden = true
            case 1:
                self.followingList.hidden = true
                self.followersList.hidden = false
            default:
                break;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var friends:[FriendProfile]
        if tableView == self.followersList {
            friends = followers
        } else {
            friends = following
        }
        let id = indexPath.row
        var gender:String
        if friends[id].gender == 0 {
            gender = "Unknown"
        } else if friends[id].gender == 1 {
            gender = "Female"
        } else {
            gender = "Male"
        }
        
        let alertController = UIAlertController(title: friends[id].nickName, message:
            "--------\nUsername: "+friends[id].userName+"\nGender: "+gender+"\nEmail: "+friends[id].email+"\nRating: "+String(friends[id].rating)+"\nNumber of Followers: "+String(friends[id].numberOfFollowers)+"\nNumber of Following: "+String(friends[id].numberOfFollowing), preferredStyle: UIAlertControllerStyle.Alert)
        
        
        
        let followAction = UIAlertAction(title: "Follow", style: .Default, handler: {
            action in
            // TODO: Submit the follow request to server
            
            
            // Done
            let alertMessage = UIAlertController(title: "Success", message: "You have followed "+friends[id].nickName, preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
        
        let unfollowAction = UIAlertAction(title: "Unfollow", style: .Default, handler: {
            action in
            // TODO: Submit the unfollow request to server
            
            
            // Done
            let alertMessage = UIAlertController(title: "Success", message: "You have unfollowed "+friends[id].nickName, preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
        
        alertController.addAction(followAction)
        alertController.addAction(unfollowAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
}
