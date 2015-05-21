//
//  CreateEventController.swift
//  Niii
//
//  Created by LinShengyi on 5/20/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class CreateEventController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var eventInfo: UITableView!
    var parentController = 0
    var picker = UIImagePickerController()
    var smallRowHeight:CGFloat = 60
    var largeRowHeight:CGFloat = 150
    var flags:[Bool] = [Bool]()
    var titleField:UITextView = UITextView()
    var descriptionField:UITextView = UITextView()
    var dayAndTimeField:UITextView = UITextView()
    var locationField:UITextView = UITextView()
    var imageField:UIImageView = UIImageView()
    var submitButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
        self.eventInfo.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectPhoto(sender: UIBarButtonItem) {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        presentViewController(picker, animated: true, completion: nil)//4
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageField.contentMode = .ScaleAspectFit //3
        imageField.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    
    @IBAction func backToEvents(sender: AnyObject) {
        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
        mainPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        mainPage.selectedIndex = parentController
        self.presentViewController(mainPage, animated:true, completion:nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for var i = flags.count; i < 6; i++ {
            flags.append(false)
        }
        return 6;
    }
    
    // Setting the height of the rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 3 || indexPath.row == 4 {
            return largeRowHeight
        } else {
            return smallRowHeight
        }
    }
    
    func submitEventInfo(gesture: UIGestureRecognizer){
        // TODO: Submit the infomation of the event to server
        // NOTE: Remember to compress the image first!!!
        // Data: titleField.text, descriptionField.text, dateAndTimeField.text, locationField.text, imageField.image
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8000/event/add/")!)
        request.HTTPMethod = "POST"
        
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString(" ")
        
        var title = titleField.text
        var location = locationField.text
        var description = descriptionField.text
        var time = self.converTime(dayAndTimeField.text as String) as String!
        
        title = title.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
        location = location.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
        description = description.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
        time = time.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
        title = title.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        location = location.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        description = description.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        let postString = "name=" + title! + "&organizor=" + User.UID + "&place=" + location! + "&description=" + description! + "&time=" + time!
        
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
            
        }
        task.resume()
        
        
        
        
        // Done
        let alertMessage = UIAlertController(title: "Success", message: "You have created the event!", preferredStyle: .Alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        if !flags[indexPath.row] {
            flags[indexPath.row] = true
            
            let tw = self.eventInfo.bounds.width
            var th : CGFloat
            
            if indexPath.row == 3 || indexPath.row == 4 {
                th = largeRowHeight
            } else {
                th = smallRowHeight
            }
            
            let subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            subView.layer.shadowColor = UIColorFromHex.color(0x0075FF).CGColor
            subView.layer.shadowOffset = CGSizeMake(0, 3.0)
            subView.layer.shadowOpacity = 0.2
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            if indexPath.row == 5 {
                submitButton.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)/3.0, sh-10)
                let image = UIImage(named: "button.png")
                submitButton.setBackgroundImage(image, forState: UIControlState.Normal)
                submitButton.setTitle("Submit", forState: .Normal)
                submitButton.setTitleColor(UIColorFromHex.color(0x0075FF), forState: .Normal)
                submitButton.addTarget(self, action: "submitEventInfo:", forControlEvents: .TouchUpInside)
                subView.addSubview(submitButton)
            } else {
                let title = UILabel(frame: CGRectMake(20, 5, (sw-40)/3.0, sh-10))
                
                if indexPath.row == 0 {
                    title.text = "Title:"
                    titleField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    titleField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    titleField.layer.cornerRadius = 5.0
                    subView.addSubview(titleField)
                } else if indexPath.row == 1 {
                    title.text = "Date & Time:"
                    dayAndTimeField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    dayAndTimeField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    dayAndTimeField.layer.cornerRadius = 5.0
                    subView.addSubview(dayAndTimeField)
                } else if indexPath.row == 2 {
                    title.text = "Location:"
                    locationField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    locationField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    locationField.layer.cornerRadius = 5.0
                    subView.addSubview(locationField)
                } else if indexPath.row == 3 {
                    title.text = "Description:"
                    descriptionField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    descriptionField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    descriptionField.layer.cornerRadius = 5.0
                    subView.addSubview(descriptionField)
                } else {
                    title.text = "Image:"
                    imageField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    imageField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    imageField.layer.cornerRadius = 5.0
                    let selectPhotoGesture = UITapGestureRecognizer(target: self, action: "selectPhoto:")
                    imageField.addGestureRecognizer(selectPhotoGesture)
                    imageField.userInteractionEnabled = true
                    subView.addSubview(imageField)
                }
                
                subView.addSubview(title)
            }
            
            cell.addSubview(subView)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell;
    }
    
    func converTime(time: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var date = dateFormatter.dateFromString(time)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
        let dateString = dateFormatter.stringFromDate(date!)
        return dateString
    }
}