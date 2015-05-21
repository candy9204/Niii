//
//  MeController.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class MeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingList: UITableView!
    var label1 = UILabel();
    var label2 = UILabel();
    var label3 = UILabel();
    var settings = [String]()
    var firstRowHeight : CGFloat = 140.0
    var otherRowHeight : CGFloat = 50.0
    var flags:[Bool] = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.settingList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        println("Count")
        self.settings = ["Name: " + User.nickname, "Sex: " + User.gender, "Rating: " + User.rating, "Favourite", "History", "Settings"]
        if !User.updated {
            updateWithHTTP()
        }
    }
    
    func updateWithHTTP(){
        var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8000/user/" + User.UID + "/profile/")!)
        request.HTTPMethod = "POST"
        var flag = true
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                flag = false
                return
            }
            
            var err: NSError?
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if  err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                flag = false
                return
            }
            
            println(jsonResult)
            
            let nickname = jsonResult["nickname"] as? String
            let g = jsonResult["gender"] as? Int
            let gender: String
            if g == 1 {
                gender = "Male"
            } else {
                gender = "Female"
            }
            let rating = jsonResult["rating"] as? String
            println(nickname)
            dispatch_async(dispatch_get_main_queue(), {
                User.nickname = nickname
                User.gender = gender as String!
                if rating != nil {
                    User.rating = rating as String!
                }
                User.updated = true
                self.label1.text = "Name: " + User.nickname
                self.label2.text = "Sex: " + User.gender
                self.label3.text = "Rating: " + User.rating
                self.label1.reloadInputViews()
                self.label2.reloadInputViews()
                self.label3.reloadInputViews()
            })
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for var i = flags.count; i < (self.settings.count-2); i++ {
            self.flags.append(false)
        }
        return self.settings.count - 2;
    }
    
    // Setting the height of the rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return firstRowHeight
        } else {
            return otherRowHeight
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.settingList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var subView:UIView!
        if !flags[indexPath.row]{
            flags[indexPath.row] = true
            
            if indexPath.row == 0 {
                let th = firstRowHeight;
                let tw = self.settingList.bounds.width;
                
                // Subview
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
                subView.layer.shadowOffset = CGSizeMake(0, 3.0)
                subView.layer.shadowOpacity = 0.2
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                // Image
                let imageName = "head.png"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 20, y: 10, width: sh-20, height: sh-20)
                subView.addSubview(imageView)
                
                // label
                let eh = (sh - 20) / 3
                label1.frame = CGRect(x: sh+30, y: 5, width: sw-sh-60, height: eh)
                label1.text = self.settings[0]
                label2.frame = CGRect(x: sh+30, y: 10+eh, width: sw-sh-60, height: eh)
                label2.text = self.settings[1]
                label3.frame = CGRect(x: sh+30, y: 15+2*eh, width: sw-sh-60, height: eh)
                label3.text = self.settings[2]
                subView.addSubview(label1)
                subView.addSubview(label2)
                subView.addSubview(label3)
            } else {
                let th = otherRowHeight;
                let tw = self.settingList.bounds.width;
                
                // Subview
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
                subView.layer.shadowOffset = CGSizeMake(0, 3.0)
                subView.layer.shadowOpacity = 0.2
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                
                // label
                let label = UILabel();
                label.frame = CGRect(x: 20, y: 5, width: sw-20, height: sh-10)
                label.text = self.settings[indexPath.row+2]
                subView.addSubview(label)
                
                // Cell
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(subView)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
//        let singleEvent = self.storyboard?.instantiateViewControllerWithIdentifier("singleEvent") as! UIViewController
//        singleEvent.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        self.presentViewController(singleEvent, animated:true, completion:nil)
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
    
    @IBAction func signOut(sender: AnyObject) {
        // TODO: Distory local metadata
        User.reset()
        // Then go back to sign in page
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("signInPage") as! UIViewController
        signInPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(signInPage, animated:true, completion:nil)
    }
}
