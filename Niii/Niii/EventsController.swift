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
    var images = [UIImage]()
    var cells:[UITableViewCell] = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.eventList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.eventList.rowHeight = 100.0
        
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
    
    @IBAction func addEvent(sender: AnyObject) {
        let createEvent = self.storyboard?.instantiateViewControllerWithIdentifier("createEventPage") as! CreateEventController
        createEvent.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        createEvent.parentController = 0
        // println("haha")
        self.presentViewController(createEvent, animated:true, completion:nil)
    }
    
    func createCells(){
        for var i = 0; i < self.events.count; i++ {
            
            var cell:UITableViewCell = self.eventList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            
            let th = self.eventList.rowHeight;
            let tw = self.eventList.bounds.width;
            
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
            label.text = self.events[i]
            subView.addSubview(label)
            
            // Cell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(subView)
            cells.append(cell)
        }
    }
    
    func loadEvents(){
        // TODO: Load events from server
        
        
        // Done
        for i in 1...7 {
            let imageName = "climbing.png"
            self.events.append("Event " + String(i))
            images.append(UIImage(named: imageName)!)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let singleEvent = self.storyboard?.instantiateViewControllerWithIdentifier("singleEventPage") as! SingleEventController
        singleEvent.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        singleEvent.parentController = 0
        self.presentViewController(singleEvent, animated:true, completion:nil)
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.setSelected(selected, animated: animated)
    }
    
    func setHightlighted(highlighted: Bool, animated: Bool) {
        self.setHightlighted(highlighted, animated: animated)
    }
}

