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
        
        createCells()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println("CHANGE!!!")
        loadResults(searchText)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadResults(text: String){
        // TODO: Load results from server
        var request = NSMutableURLRequest(URL: NSURL(string: "http://52.25.65.141:8000/search/")!)
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
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if  err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
                return
            }
            
            println(jsonResult)
            
            let res = jsonResult["results"] as! NSArray
            dispatch_async(dispatch_get_main_queue(), {
                
                self.results = []
                self.images = []
                for r in res {
                    let type = r["type"] as! Int
                    if type == 0 {
                        let name = r["name"] as! String
                        let id = r["id"] as! Int
                        let place = r["place"] as! String
                        let time = self.timeToString(r["time"] as! String)
                        self.results.append([String(type), name, String(id), place, time])
                        //TODO: Image for category!!!
                        let imageName = "climbing.png"
                        self.images.append(UIImage(named: imageName)!)
                    } else {
                        let name = r["nickname"] as! String
                        let id = r["id"] as! Int
                        self.results.append([String(type), name, String(id)])
                        //TODO: User Image URL!!!
                        let imageName = "head.png"
                        self.images.append(UIImage(named: imageName)!)
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
            println(results[i][1])
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
            label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: sh-10)
            label.text = self.results[i][1]
            
            //TODO: Format for subtitle
            if self.results[i][0] == "0" {
                let label2 = UILabel();
                label2.frame = CGRect(x: sh+30, y: 3, width: sw-sh-30, height: sh-10)
                label2.text = "Location: " + self.results[i][3] + "   Time: " + self.results[i][4]
                subView.addSubview(label2)
            }
            subView.addSubview(label)
            
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
}