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
    var bounds: CGRect = UIScreen.mainScreen().bounds
    var cells:[UITableViewCell] = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.settingList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.settings = ["Name: " + User.nickname, "Gender: " + User.gender, "Rating: " + User.rating, "Favourite", "History", "Settings"]
        if !User.updated {
            updateWithHTTP()
        }
        
        createCells()
    }
    
    func createCells(){
        cells = []
        for var i = 0; i < self.settings.count-2; i++ {
            
            var cell:UITableViewCell = self.settingList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            var subView:UIView!
            let tw = self.bounds.width
            
            if i == 0 {
                let th = firstRowHeight
                
                // Subview
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                // Image
                let image: UIImage!
                if let img = User.photo {
                    image = img
                } else {
                    let imageName = "head.png"
                    image = UIImage(named: imageName)
                }
                
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 20, y: 10, width: sh-20, height: sh-20)
                subView.addSubview(imageView)
                
                // label
                let eh = (sh - 20) / 3
                label1.frame = CGRect(x: sh+30, y: 5, width: sw-sh-60, height: eh)
                label1.text = "Name: " + User.nickname
                label1.font = UIFont(name: "AmericanTypewriter", size: 20)
                label2.frame = CGRect(x: sh+30, y: 10+eh, width: sw-sh-60, height: eh)
                label2.text = "Gender: " + User.gender
                label2.font = UIFont(name: "AmericanTypewriter", size: 20)
                label3.frame = CGRect(x: sh+30, y: 15+2*eh, width: sw-sh-60, height: eh)
                label3.text = "Rating: " + User.rating
                label3.font = UIFont(name: "AmericanTypewriter", size: 20)
                subView.addSubview(label1)
                subView.addSubview(label2)
                subView.addSubview(label3)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else {
                let th = otherRowHeight
                // Subview
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                // Image
                let imageName:String
                if i == 1 {
                    imageName = "like.png"
                } else if i == 2 {
                    imageName = "history.png"
                } else {
                    imageName = "settings.png"
                }
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
                subView.addSubview(imageView)
                
                // label
                let label = UILabel();
                label.frame = CGRect(x: 20+2*sh, y: 5, width: sw-sh-40, height: sh-10)
                label.text = self.settings[i+2]
                label.font = UIFont(name: "AmericanTypewriter", size: 20)
                subView.addSubview(label)
                
                // Cell
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(subView)
            
            cells.append(cell)
        }
    }
    
    func updateWithHTTP(){
        var request = NSMutableURLRequest(URL: NSURL(string: User.URLbase + "/user/" + User.UID + "/profile/")!)
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
                let photoUrl = jsonResult["photo"] as? String
                
                self.label1.text = "Name: " + User.nickname
                self.label2.text = "Gender: " + User.gender
                self.label3.text = "Rating: " + User.rating
                self.label1.reloadInputViews()
                self.label2.reloadInputViews()
                self.label3.reloadInputViews()
                
                if let url = photoUrl {
                    let urlString = User.URLbase + url  //User.URLbase + url
                    let request: NSURLRequest = NSURLRequest(URL: NSURL(string: urlString)!)
                    let mainQueue = NSOperationQueue.mainQueue()
                    NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                User.photo = UIImage(data: data)
                                self.createCells()
                                self.settingList.reloadData()
                            })
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
                }

            })
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        return cells[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == 3 {
            let settingsPage = self.storyboard?.instantiateViewControllerWithIdentifier("settingsPage") as! SettingsController
            settingsPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            settingsPage.parentController = 3
            self.presentViewController(settingsPage, animated:true, completion:nil)
        } else if indexPath.row == 2 {
            let fAndHListPage = self.storyboard?.instantiateViewControllerWithIdentifier("fAndHListPage") as! FAndHListController
            fAndHListPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            fAndHListPage.parentController = 3
            fAndHListPage.parentCall = 1
            self.presentViewController(fAndHListPage, animated:true, completion:nil)
        } else if indexPath.row == 1 {
            let fAndHListPage = self.storyboard?.instantiateViewControllerWithIdentifier("fAndHListPage") as! FAndHListController
            fAndHListPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            fAndHListPage.parentController = 3
            fAndHListPage.parentCall = 0
            self.presentViewController(fAndHListPage, animated:true, completion:nil)
        }
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
