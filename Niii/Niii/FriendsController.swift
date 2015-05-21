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
    var followers = [String]()
    var following = [String]()
    var images_followers = [UIImage]()
    var images_following = [UIImage]()
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFriends(){
        // TODO: Load the information of friends from database
        let imageName = "me.png"
        // Followers
        self.followers = ["Li Ding", "Yilin Xiong", "Mengdi Zhang", "Di Li"]
        self.images_followers.append(UIImage(named: imageName)!)
        self.images_followers.append(UIImage(named: imageName)!)
        self.images_followers.append(UIImage(named: imageName)!)
        self.images_followers.append(UIImage(named: imageName)!)
        // Following
        self.following = ["Yilin Xiong", "Li Ding", "Jiangyu"]
        self.images_following.append(UIImage(named: imageName)!)
        self.images_following.append(UIImage(named: imageName)!)
        self.images_following.append(UIImage(named: imageName)!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  tableView == self.followersList {
            return self.followers.count;
        } else {
            return self.following.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.followersList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var subView:UIView!
        
        if tableView == self.followersList {
            
            let th = self.followersList.rowHeight;
            let tw = self.followersList.bounds.width;
            
            // Subview
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            // Image
            let imageView = UIImageView(image: images_followers[indexPath.row])
            imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
            subView.addSubview(imageView)
            
            // label
            let label = UILabel();
            label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: sh-10)
            label.text = self.followers[indexPath.row]
            subView.addSubview(label)
            
            // Cell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.backgroundColor = UIColor.clearColor();
            cell.contentView.addSubview(subView)
            
        } else {
            
            let th = self.followingList.rowHeight;
            let tw = self.followingList.bounds.width;
            
            // Subview
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            // Image
            let imageView = UIImageView(image: images_following[indexPath.row])
            imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
            subView.addSubview(imageView)
            
            // label
            let label = UILabel();
            label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: sh-10)
            label.text = self.following[indexPath.row]
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
        if tableView == self.followersList {
            let followers = self.storyboard?.instantiateViewControllerWithIdentifier("singleFriendPage") as! SingleFriendController
            followers.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            followers.parentController = 2
            followers.parentTab = 1
            self.presentViewController(followers, animated:true, completion:nil)
        } else {
            let following = self.storyboard?.instantiateViewControllerWithIdentifier("singleFriendPage") as! SingleFriendController
            following.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            following.parentController = 2
            following.parentTab = 0
            self.presentViewController(following, animated:true, completion:nil)
        }
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
}
