//
//  FirstViewController.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventList: UITableView!
    var events = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.eventList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.eventList.rowHeight = 100.0
        self.events = ["Event 1", "Event 2", "Event 3"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let th = self.eventList.rowHeight;
        let tw = self.eventList.bounds.width;
        
        // Subview
        var subView:UIView!
        subView = UIView(frame: CGRectMake(5, 5, tw-25, th-10))
        subView.backgroundColor = UIColor.whiteColor()
        subView.layer.shadowOpacity = 1.55;
        subView.layer.shadowColor = UIColor(red: 53/255.0, green: 143/255.0, blue: 185/255.0, alpha: 1.0).CGColor
        subView.layer.cornerRadius = 3.0
        subView.layer.shadowOpacity = 0.5
        
        let sh = subView.bounds.height
        let sw = subView.bounds.width
        
        // Image
        let imageName = "climbing.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 5, y: 5, width: sh-10, height: sh-10)
        subView.addSubview(imageView)
        
        // label
        let label = UILabel();
        label.frame = CGRect(x: sh+5, y: 5, width: sw-sh-10, height: sh-10)
        label.text = self.events[indexPath.row]
        subView.addSubview(label)
        
        // Cell
        var cell:UITableViewCell = self.eventList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor = UIColor.clearColor();
        cell.contentView.addSubview(subView)
        // cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let singleEvent = self.storyboard?.instantiateViewControllerWithIdentifier("singleEvent") as! UIViewController
        self.presentViewController(singleEvent, animated:true, completion:nil)
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
}

