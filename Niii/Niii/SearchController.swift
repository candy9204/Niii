//
//  SearchController.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var resultsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var results = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.resultsList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.resultsList.rowHeight = 100.0
        self.results = ["Event 1", "Event 2", "Event 3"]
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColorFromHex.color(0x0075FF).CGColor
        self.searchBar.layer.backgroundColor = UIColorFromHex.color(0x0075FF).CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let th = self.resultsList.rowHeight;
        let tw = self.resultsList.bounds.width;
        
        // Subview
        var subView:UIView!
        subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
        subView.backgroundColor = UIColor.whiteColor()
        subView.layer.shadowOpacity = 1.55;
        subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
        subView.layer.shadowOffset = CGSizeMake(0, 3.0)
        subView.layer.shadowOpacity = 0.2
        
        
        let sh = subView.bounds.height
        let sw = subView.bounds.width
        
        // Image
        let imageName = "climbing.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 20, y: 5, width: sh-10, height: sh-10)
        subView.addSubview(imageView)
        
        // label
        let label = UILabel();
        label.frame = CGRect(x: sh+30, y: 5, width: sw-sh-30, height: sh-10)
        label.text = self.results[indexPath.row]
        subView.addSubview(label)
        
        // Cell
        var cell:UITableViewCell = self.resultsList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor = UIColor.clearColor();
        cell.contentView.addSubview(subView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let singleEvent = self.storyboard?.instantiateViewControllerWithIdentifier("singleEventPage") as! SingleEventController
        singleEvent.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        singleEvent.parentController = 1
        self.presentViewController(singleEvent, animated:true, completion:nil)
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
}