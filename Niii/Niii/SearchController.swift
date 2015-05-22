//
//  SearchController.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    @IBOutlet weak var resultsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var results = [[String]]()
    var images = [UIImage]()
    var cells:[UITableViewCell] = [UITableViewCell]()
    var bounds: CGRect = UIScreen.mainScreen().bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.resultsList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.resultsList.rowHeight = 100.0
        self.searchBar.delegate = (self as UISearchBarDelegate)
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColorFromHex.color(0x0075FF).CGColor
        self.searchBar.layer.backgroundColor = UIColorFromHex.color(0x0075FF).CGColor
        loadResults("")
        createCells()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadResults(searchText)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadResults(text: String){
        // TODO: Load results from server
        var request = NSMutableURLRequest(URL: NSURL(string: User.URLbase + "/search/")!)
        request.HTTPMethod = "POST"
        
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString(" ")
        
        var query = text
        
        query = query.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
        query = query.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        let postString = "searchString=" + query
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            var jsonResult: NSDictionary!
            if json != nil {
                jsonResult = json!
            } else {
                return
            }
            
            if  err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                return
            }
            
            let res = jsonResult["results"] as! NSArray
            dispatch_async(dispatch_get_main_queue(), {
                
                self.results = []
                self.images = []
                for var i = 0; i < res.count; i++ {
                    let r = res[i] as! NSDictionary
                    let type = r["type"] as! Int
                    if type == 0 {
                        let name = r["name"] as! String
                        let id = r["id"] as! Int
                        let place = r["place"] as! String
                        let time = self.timeToString(r["time"] as! String)
                        self.results.append([String(type), name, String(id), place, time])
                        //TODO: Image for category!!!
                        var imageName : String
                        if let imgname = r["category"] as? String {
                            imageName = imgname + ".png"
                        }
                        else {
                            imageName = "climbing.png"
                        }
                        self.images.append(UIImage(named: imageName)!)
                    } else {
                        let nickname = r["nickname"] as! String
                        let username = r["username"] as! String
                        let imageURL = r["photo"] as? String
                        let g = r["gender"] as! Int
                        var gender = "Female"
                        if g == 1 {
                            gender = "Male"
                        }
                        
                        let email = r["email"] as! String
                        var rating = 0
                        if let r = r["rating"] as? Int {
                            rating = r
                        }
                        let id = r["id"] as! Int
                        self.results.append([String(type), nickname, String(id), username, gender, email, String(rating)])
                        //TODO: User Image URL!!!
                        let photoURL = r["photo"] as? String
                        let imageName = "head.png"
                        self.images.append(UIImage(named: imageName)!)
                        if let url = photoURL {
                            let urlString = User.URLbase + url  //User.URLbase + url
                            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: urlString)!)
                            let mainQueue = NSOperationQueue.mainQueue()
                            let fow = i
                            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                                if error == nil {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        let image = UIImage(data: data)
                                        if fow < self.images.count && image != nil{
                                            self.images[fow] = image!
                                            self.createCells()
                                            self.resultsList.reloadData()
                                        }
                                    })
                                }
                                else {
                                    println("Error: \(error.localizedDescription)")
                                }
                            })
                        }
                    }
                }
                self.createCells()
                self.resultsList.reloadData()
                
            })
            
        }
        task.resume()
    }
    
    func createCells() {
        self.cells = []
        for var i = 0; i < self.results.count; i++ {
            var cell:UITableViewCell = self.resultsList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            let th = self.resultsList.rowHeight;
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
            label.text = self.results[i][1]
            label.font = UIFont(name: "AmericanTypewriter", size: 18)
            subView.addSubview(label)
            
            //TODO: Format for subtitle
            if self.results[i][0] == "0" {
                let label2 = UILabel();
                label2.frame = CGRect(x: sh+30, y: 5+(sh-10)/2.0, width: sw-sh-30, height: (sh-10)/4.0)
                label2.text = "Location: " + self.results[i][3]
                label2.font = UIFont(name: "AlNile", size: 12)
                subView.addSubview(label2)
            }
            if self.results[i][0] == "0" {
                let label2 = UILabel();
                label2.frame = CGRect(x: sh+30, y: 5+(sh-10)*3.0/4.0, width: sw-sh-30, height: (sh-10)/4.0)
                label2.text = "Time: " + self.results[i][4]
                label2.font = UIFont(name: "AlNile", size: 12)
                subView.addSubview(label2)
            }
            
            // Cell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.backgroundColor = UIColor.clearColor();
            cell.contentView.addSubview(subView)
            
            cells.append(cell)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if results[indexPath.row][0] == "0" {
            User.eventID = results[indexPath.row][2]
            let singleEvent = self.storyboard?.instantiateViewControllerWithIdentifier("singleEventPage") as! SingleEventController
            singleEvent.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            singleEvent.parentController = 1
            self.presentViewController(singleEvent, animated:true, completion:nil)
        } else {
            
            var msg = "--------\nUsername: " + self.results[indexPath.row][3]
            msg += "\nGender: " + self.results[indexPath.row][4]
            msg += "\nEmail: " + self.results[indexPath.row][5]
            msg += "\nRating: " + self.results[indexPath.row][6]
            
            let alertController = UIAlertController(title: self.results[indexPath.row][1], message: msg, preferredStyle: UIAlertControllerStyle.Alert)
            
            
            
            let followAction = UIAlertAction(title: "Follow", style: .Default, handler: {
                action in
                // TODO: Submit the follow request to server
                
                self.followAction(self.results[indexPath.row][2])
                
                // Done
                let alertMessage = UIAlertController(title: "Success", message: "You have followed " + self.results[indexPath.row][1], preferredStyle: .Alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMessage, animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
            
            
            alertController.addAction(followAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
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
    
    func followAction(id: String) {
        let urlPath = User.URLbase + "/user/" + User.UID + "/followings/add/?following_id=" + id
        
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
            
        })
        task.resume()
        
    }
}