//
//  FAndHListController.swift
//  Niii
//
//  Created by LinShengyi on 5/21/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class FAndHListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventList: UITableView!
    @IBOutlet weak var FHtitle: UILabel!
    var parentController = 0
    var parentCall = 0
    var events = [[String]]()
    var images = [UIImage]()
    var cells:[UITableViewCell] = [UITableViewCell]()
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.eventList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.eventList.rowHeight = 100.0
        
        if self.parentCall == 0 {
            FHtitle.text = "Favourite"
        } else {
            FHtitle.text = "History"
        }
        
        
        loadEvents()
        createCells()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count;
    }
    
    @IBAction func backToMe(sender: AnyObject) {
        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
        mainPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        mainPage.selectedIndex = parentController
        self.presentViewController(mainPage, animated:true, completion:nil)
    }
    
    func createCells(){
        for var i = 0; i < self.events.count; i++ {
            
            var cell:UITableViewCell = self.eventList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            
            let th = self.eventList.rowHeight;
            let tw = self.bounds.width;
            
            // Subview
            var subView:UIView!
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            // Image
            let imageView = UIImageView(image: images[i])
            imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
            subView.addSubview(imageView)
            
            // label
            let label = UILabel();
            label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: (sh-10)/2.0)
            label.text = self.events[i][0]
            label.font = UIFont(name: "AmericanTypewriter", size: 18)
            subView.addSubview(label)
            
            // TODO: Add Location and Time
            let label2 = UILabel();
            label2.frame = CGRect(x: sh+30, y: 5+(sh-10)/2.0, width: sw-sh-30, height: (sh-10)/4.0)
            label2.text = "Location: " + self.events[i][2]
            label2.font = UIFont(name: "AlNile", size: 12)
            subView.addSubview(label2)
            
            let label3 = UILabel();
            label3.frame = CGRect(x: sh+30, y: 5+(sh-10)*3.0/4.0, width: sw-sh-30, height: (sh-10)/4.0)
            label3.text = "Time: " + self.events[i][3]
            label3.font = UIFont(name: "AlNile", size: 12)
            subView.addSubview(label3)
            
            // Cell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(subView)
            cells.append(cell)
        }
    }
    
    func loadEvents(){
        // TODO: Load events from server
        // parentCall == 0 for Favourite, parentCall == 1 for History
        var urlPath : String
        if parentCall == 1{
            urlPath = User.URLbase + "/user/" + User.UID + "/participations/"
        }
        else {
            urlPath = User.URLbase + "/user/" + User.UID + "/favorites/"
        }
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        println("before task")
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("in task")
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
            
            println(jsonResult)
            var res : NSArray
            if self.parentCall == 1 {
                res = jsonResult["participations"] as! NSArray
            }
            else{
                res = jsonResult["favorites"] as! NSArray
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                self.events = []
                self.images = []
                for r in res {
                    let name = r["name"] as! String
                    let id = r["id"] as! Int
                    //let place = r["place"] as String
                    //let time = self.timeToString(r["time"] as String)
                    let time = "test time"
                    let place = "test place"
                    self.events.append([name, String(id), place, time])
                    //TODO: Image for category!!!
                    let imageName = "climbing.png"
                    self.images.append(UIImage(named: imageName)!)
            
                }
                self.createCells()
                self.eventList.reloadData()
            })
        })
        task.resume()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        User.eventID = self.events[indexPath.row][1]
        let singleEvent = self.storyboard?.instantiateViewControllerWithIdentifier("singleEventPage") as! SingleEventController
        singleEvent.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        singleEvent.parentController = 0
        self.presentViewController(singleEvent, animated:true, completion:nil)
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    func timeToString(time: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ssxxx"
        var date = dateFormatter.dateFromString(time)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ss.SSSxxx"
            date = dateFormatter.dateFromString(time)
        }
        dateFormatter.dateFormat = "MMM dd"
        let dateString = dateFormatter.stringFromDate(date!)
        return dateString
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
}