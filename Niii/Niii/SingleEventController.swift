//
//  SingleEventController.swift
//  Niii
//
//  Created by LinShengyi on 4/30/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit
import AVFoundation

class SingleEventController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventInfo: UITableView!
    var event:Event = Event()
    var parentController = 0
    var firstRowHeight:CGFloat = 200.0
    var secondRowHeight:CGFloat = 100.0
    var thirdRowHeight:CGFloat = 50.0
    var otherRowHeight:CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.eventInfo.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Get event information from database
        getInformationFromDatabase()
    }
    
    
    @IBAction func BackToEvents(sender: AnyObject) {
        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
        mainPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        mainPage.selectedIndex = parentController;
        self.presentViewController(mainPage, animated:true, completion:nil)
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.comments.count + 3;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var subView:UIView!
        let tw = self.eventInfo.bounds.width
        
        if(indexPath.row == 0){
            let th = firstRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
//            // Subview
//            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
//            subView.backgroundColor = UIColor.whiteColor()
//            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
//            subView.layer.shadowOffset = CGSizeMake(0, 3.0)
//            subView.layer.shadowOpacity = 0.2
//            let sh = subView.bounds.height
//            let sw = subView.bounds.width
//            
//            // Image
//            let imageName = "head.png"
//            let image = UIImage(named: imageName)
//            let imageView = UIImageView(image: image!)
//            imageView.frame = CGRect(x: 20, y: 10, width: sh-20, height: sh-20)
//            subView.addSubview(imageView)
//            
//            // label
//            let eh = (sh - 20) / 3
//            let label1 = UILabel();
//            label1.frame = CGRect(x: sh+30, y: 5, width: sw-sh-60, height: eh)
//            label1.text = self.settings[0]
//            let label2 = UILabel();
//            label2.frame = CGRect(x: sh+30, y: 10+eh, width: sw-sh-60, height: eh)
//            label2.text = self.settings[1]
//            let label3 = UILabel();
//            label3.frame = CGRect(x: sh+30, y: 15+2*eh, width: sw-sh-60, height: eh)
//            label3.text = self.settings[2]
//            subView.addSubview(label1)
//            subView.addSubview(label2)
//            subView.addSubview(label3)
            
            
        } else if(indexPath.row == 1){
            let th = secondRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            
        } else if(indexPath.row == 2){
            let th = thirdRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(0, 3.0)
            subView.layer.shadowOpacity = 0.2
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            let label = UILabel();
            label.frame = CGRect(x: 5, y: 5, width: sw-10, height: sh-10)
            label.text = "Comments"
            label.font = UIFont(name: label.font.fontName, size: 20)
            subView.addSubview(label)
            
        } else{
            let th = otherRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
        }
        
        cell.backgroundColor = UIColor.clearColor();
        cell.contentView.addSubview(subView)
        
        return cell;
    }
    
    // Setting the height of the rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return firstRowHeight
        } else if(indexPath.row == 1){
            return secondRowHeight
        } else if(indexPath.row == 2){
            return thirdRowHeight
        } else{
            return otherRowHeight
        }
    }
    
    func getInformationFromDatabase(){
        
        // TODO: Get information from database
        event.name = "Go Climbing!"
        event.address = "New York"
        event.date = "June 1, 2015"
        event.followers.append(UIImage(named:"head.jpg")!)
        event.followers.append(UIImage(named:"head.jpg")!)
        event.comments.append(["Yilin", "Interesting!!!", "April 29, 2015"])
        event.comments.append(["Mengdi", "Yes!!! Very interesting!!!", "April 30, 2015"])
    }
}