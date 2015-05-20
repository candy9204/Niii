//
//  SingleEventController.swift
//  Niii
//
//  Created by LinShengyi on 4/30/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit
import MapKit

class SingleEventController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventInfo: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var event:Event = Event()
    var parentController = 0
    var infoRowHeight:CGFloat = 200.0
    var participantsRowHeight:CGFloat = 100.0
    var titleRowHeight:CGFloat = 50.0
    var commentRowHeight:CGFloat = 100.0
    
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
        return event.comments.count + 4;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var subView:UIView!
        let tw = self.eventInfo.bounds.width
        
        if(indexPath.row == 0){
            let th = infoRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            // Subview
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(0, 3.0)
            subView.layer.shadowOpacity = 0.2
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width

            // TODO: Add map
            let w = min(sw/2.0-25, sh-10)
            let os = (sw/2.0 - w) / 2.0
            let mapView = MKMapView(frame: CGRectMake(sw/2.0+os, os, w, w))
            
            // holder name
            let eh = (sh - 25) / 5.0
            let label1 = UILabel()
            label1.frame = CGRect(x: 20, y: 5, width: sw/2.0-25, height: eh)
            label1.text = event.holderName
            
            // rating
            let subw = min(sw/20.0, eh)
            if(event.rating > 0){
                for i in 0...(event.rating-1) {
                    let image = UIImage(named: "starY.png")
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: 20+CGFloat(i)*subw, y: 10+eh, width: subw, height: subw)
                    subView.addSubview(imageView)
                }
            }
            if(event.rating < 4){
                for i in event.rating...4{
                    let image = UIImage(named: "starN.png")
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: 20+CGFloat(i)*subw, y: 10+eh, width: subw, height: subw)
                    subView.addSubview(imageView)
                }
            }
            let image = UIImage(named: "rating.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 20+6.0*subw, y: 10+eh, width: subw, height: subw)
            subView.addSubview(imageView)
            
            
            // address
            let label2 = UILabel()
            label2.frame = CGRect(x: 20, y: 20+2*eh, width: sw/2.0-25, height: eh)
            label2.text = event.address
            
            // date
            let label3 = UILabel()
            label3.frame = CGRect(x: 20, y: 25+3*eh, width: sw/2.0-25, height: eh)
            label3.text = event.date
            
            subView.addSubview(label1)
            subView.addSubview(label2)
            subView.addSubview(label3)
            subView.addSubview(mapView)
            
            
            
        } else if(indexPath.row == 1){
            let th = titleRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(-200.0, 3.0)
            subView.layer.shadowOpacity = 0.1
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            let label = UILabel();
            label.frame = CGRect(x: 20, y: 5, width: sw-10, height: sh-10)
            label.text = "Participants:"
            label.font = UIFont(name: label.font.fontName, size: 20)
            subView.addSubview(label)
            
        } else if(indexPath.row == 2){
            let th = participantsRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(0, 3.0)
            subView.layer.shadowOpacity = 0.2
        
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            for i in 0...(event.followers.count-1){
                let image = event.followers[i]
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 20+CGFloat(i)*sh, y: 10, width: sh-20, height: sh-20)
                subView.addSubview(imageView)
            }
            
        } else if(indexPath.row == 3){
            let th = titleRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(-200.0, 3.0)
            subView.layer.shadowOpacity = 0.1
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            let label = UILabel();
            label.frame = CGRect(x: 20, y: 5, width: sw-10, height: sh-10)
            label.text = "Comments:"
            label.font = UIFont(name: label.font.fontName, size: 20)
            subView.addSubview(label)
            
        } else{
            let th = commentRowHeight
            
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(-50.0, 3.0)
            subView.layer.shadowOpacity = 0.1
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            let subh = (sh - 10) / 2.0
            
            let comment = event.comments[indexPath.row-4]
            let label_name = UILabel()
            label_name.frame = CGRect(x: 20, y: 5, width: (sw-10)/2.0, height: subh)
            label_name.text = comment[0] + ":"
            label_name.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
                
            let label_time = UILabel()
            label_time.text = comment[1]
            label_time.frame = CGRect(x: 20+(sw-10)/2.0, y: 5, width: (sw-10)/2.0, height: subh)
            label_time.font = UIFont(name:label_time.font.fontName, size: 10.0)
                
            let label_content = UILabel()
            label_content.text = comment[2]
            label_content.frame = CGRect(x: 20, y: 5+subh, width: sw-10, height: subh)
                
            subView.addSubview(label_name)
            subView.addSubview(label_time)
            subView.addSubview(label_content)
        }
        
        cell.backgroundColor = UIColor.clearColor();
        cell.contentView.addSubview(subView)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell;
    }
    
    // Setting the height of the rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return infoRowHeight
        } else if(indexPath.row == 1){
            return titleRowHeight
        } else if(indexPath.row == 2){
            return participantsRowHeight
        } else if(indexPath.row == 3){
            return titleRowHeight
        } else{
            return commentRowHeight
        }
    }
    
    func getInformationFromDatabase(){
        
        // TODO: Get information from database
        event.eventName = "Go Climbing!"
        event.holderName = "Shengyi Lin"
        event.address = "New York"
        event.date = "June 1, 2015"
        event.followers.append(UIImage(named:"head.jpg")!)
        event.followers.append(UIImage(named:"head.jpg")!)
        event.comments.append(["Yilin", "11:00am April 29, 2015", "Interesting!!!"])
        event.comments.append(["Mengdi", "12:00pm April 30, 2015", "Yes!!! Very interesting!!!"])
        event.rating = 5
        
        titleLabel.text = event.eventName
    }
}