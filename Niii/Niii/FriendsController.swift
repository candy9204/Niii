//
//  FriendsController.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
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
//        self.searchBar.layer.borderWidth = 1
//        self.searchBar.layer.borderColor = UIColorFromHex.color(0x0075FF).CGColor
//        self.searchBar.layer.backgroundColor = UIColorFromHex.color(0x0075FF).CGColor
        
        loadFriends()
        createCells()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //loadResults(searchText)
    } //TODO remove search bar
    
    func createCells(){
        cells_followers = []
        cells_following = []
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
            label.font = UIFont(name: "AmericanTypewriter", size: 18)
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
            label.font = UIFont(name: "AmericanTypewriter", size: 18)
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
    
    func loadFollowers(){
        let urlPath = User.URLbase + "/user/" + User.UID + "/followers/"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if  err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                return
            }
            
            let fers = jsonResult["followers"] as! NSArray
            
            println(jsonResult)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                for var i = 0; i < fers.count; i++ {
                    let fer = fers[i] as! NSDictionary
                    let id = String(fer["id"] as! Int)
                    let nickname = fer["nickname"] as! String
                    let username = fer["username"] as! String
                    let imageURL = fer["photo"] as? String
                    let imageName = "head.png"
                    let gender = fer["gender"] as! Int
                    let email = fer["email"] as! String
                    var rating = 0
                    if let r = fer["rating"] as? Int {
                        rating = r
                    }
                    self.followers.append(FriendProfile(id: id, userName: username, nickName: nickname, rating: rating, email: email, numberOfFollowers: 5, numberOfFollowing: 6, gender: gender, image: UIImage(named: imageName)!, updated: true))
                    
                    if let url = imageURL {
                        let urlString = User.URLbase + url  //User.URLbase + url
                        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: urlString)!)
                        let mainQueue = NSOperationQueue.mainQueue()
                        let fow = i
                        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                            if error == nil {
                                dispatch_async(dispatch_get_main_queue(), {
                                    let image = UIImage(data: data)
                                    if fow < self.followers.count && image != nil {
                                        self.followers[fow].image = image!
                                        self.createCells()
                                        self.followersList.reloadData()
                                    }
                                })
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                        })
                    }
                }
                
                
                self.createCells()
                self.followersList.reloadData()
                
            })
        })
        task.resume()

    }
    
    func loadFollowing(){
        
        let urlPath = User.URLbase + "/user/" + User.UID + "/followings/"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if  err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                return
            }
            
            let fins = jsonResult["followings"] as! NSArray
            
            dispatch_async(dispatch_get_main_queue(), {
                
                for var i = 0; i < fins.count; i++ {
                    let fin = fins[i] as! NSDictionary
                    let id = String(fin["id"] as! Int)
                    let nickname = fin["nickname"] as! String
                    let username = fin["username"] as! String
                    let imageURL = fin["photo"] as? String
                    let gender = fin["gender"] as! Int
                    let email = fin["email"] as! String
                    var rating = 0
                    if let r = fin["rating"] as? Int {
                        rating = r
                    }
                    let imageName = "head.png"
                    self.following.append(FriendProfile(id: id, userName: username, nickName: nickname, rating: rating, email: email, numberOfFollowers: 5, numberOfFollowing: 6, gender: gender, image: UIImage(named: imageName)!, updated: true))
                    
                    if let url = imageURL {
                        let urlString = User.URLbase + url  //User.URLbase + url
                        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: urlString)!)
                        let mainQueue = NSOperationQueue.mainQueue()
                        let fow = i
                        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                            if error == nil {
                                dispatch_async(dispatch_get_main_queue(), {
                                    let image = UIImage(data: data)
                                    if fow < self.following.count && image != nil {
                                        self.following[fow].image = UIImage(data: data)!
                                        self.createCells()
                                        self.followingList.reloadData()
                                    }
                                })
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                        })
                    }

                }
                
                
                self.createCells()
                self.followingList.reloadData()
                
            })
        })
        task.resume()
    }
    
    func loadFriends(){
        // TODO: Load the information of friends from database
        self.loadFollowers()
        self.loadFollowing()
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
            gender = "Female"
        } else {
            gender = "Male"
        }
        
        let alertController = UIAlertController(title: friends[id].nickName, message:
            "--------\nUsername: "+friends[id].userName+"\nGender: "+gender+"\nEmail: "+friends[id].email+"\nRating: "+String(friends[id].rating), preferredStyle: UIAlertControllerStyle.Alert)
        
        
        
        let followAction = UIAlertAction(title: "Follow", style: .Default, handler: {
            action in
            // TODO: Submit the follow request to server
            
            self.followAction("add", friend: friends[id])
            
            // Done
            let alertMessage = UIAlertController(title: "Success", message: "You have followed "+friends[id].nickName, preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
        
        let unfollowAction = UIAlertAction(title: "Unfollow", style: .Default, handler: {
            action in
            // TODO: Submit the unfollow request to server
            
            
            self.followAction("remove", friend: friends[id])
            
            // Done
            let alertMessage = UIAlertController(title: "Success", message: "You have unfollowed "+friends[id].nickName, preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
        
        if self.find(friends[id]) == nil {
            alertController.addAction(followAction)
        } else {
            alertController.addAction(unfollowAction)
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func followAction(action: String, friend: FriendProfile) {
        let urlPath = User.URLbase + "/user/" + User.UID + "/followings/" + action + "/?following_id=" + friend.id
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if  err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if action == "remove" {
                    if let index = self.find(friend)
                    {
                        self.following.removeAtIndex(index)
                    }
                } else {
                    if self.find(friend) == nil
                    {
                        self.following.append(friend)
                    }
                }
                
                self.createCells()
                self.followingList.reloadData()

            })
            
        })
        task.resume()

    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
    
    func find (friend: FriendProfile) -> Int? {
        for var i = 0; i < self.following.count; i++ {
            let ff = following[i] as FriendProfile
            if ff.id == friend.id {
                return i
            }
        }
        return nil
    }
}
