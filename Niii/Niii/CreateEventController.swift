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
    var titleField:UITextView = UITextView()
    var descriptionField:UITextView = UITextView()
    var dayAndTimeField:UITextView = UITextView()
    var locationField:UITextView = UITextView()
    var categoryField:UITextView = UITextView()
    var imageField:UIImageView = UIImageView()
    var submitButton:UIButton = UIButton()
    var cells:[UITableViewCell] = [UITableViewCell]()
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
        self.eventInfo.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        createCells()
    }
    
    func createCells(){
        for var i = 0; i < 6; i++ {
            var cell:UITableViewCell = self.eventInfo.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            let tw = self.bounds.width
            var th : CGFloat
            
            if i == 4 {
                th = largeRowHeight
            } else {
                th = smallRowHeight
            }
            
            let subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            if i == 5 {
                submitButton.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)/3.0, sh-10)
                let image = UIImage(named: "button.png")
                submitButton.setBackgroundImage(image, forState: UIControlState.Normal)
                submitButton.setTitle("Submit", forState: .Normal)
                submitButton.setTitleColor(UIColorFromHex.color(0x0075FF), forState: .Normal)
                submitButton.addTarget(self, action: "submitEventInfo:", forControlEvents: .TouchUpInside)
                subView.addSubview(submitButton)
            } else {
                let title = UILabel(frame: CGRectMake(20, 5, (sw-40)/3.0, sh-10))
                
                if i == 0 {
                    title.text = "Title:"
                    titleField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    titleField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    titleField.layer.cornerRadius = 5.0
                    subView.addSubview(titleField)
                } else if i == 1 {
                    title.text = "Date & Time:"
                    dayAndTimeField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    dayAndTimeField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    dayAndTimeField.layer.cornerRadius = 5.0
                    subView.addSubview(dayAndTimeField)
                } else if i == 2 {
                    title.text = "Location:"
                    locationField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    locationField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    locationField.layer.cornerRadius = 5.0
                    subView.addSubview(locationField)
                } else if i == 3 {
                    title.text = "Category:"
                    categoryField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    categoryField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    categoryField.layer.cornerRadius = 5.0
                    subView.addSubview(categoryField)
                } else if i == 4 {
                    title.text = "Description:"
                    descriptionField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                    descriptionField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                    descriptionField.layer.cornerRadius = 5.0
                    subView.addSubview(descriptionField)
//                } else {
//                    title.text = "Image:"
//                    imageField.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
//                    imageField.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
//                    imageField.layer.cornerRadius = 5.0
//                    let selectPhotoGesture = UITapGestureRecognizer(target: self, action: "selectPhoto:")
//                    imageField.addGestureRecognizer(selectPhotoGesture)
//                    imageField.userInteractionEnabled = true
//                    subView.addSubview(imageField)
                }
                
                subView.addSubview(title)
            }
            
            cell.addSubview(subView)
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cells.append(cell)
        }
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
        return 6;
    }
    
    // Setting the height of the rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return largeRowHeight
        } else {
            return smallRowHeight
        }
    }
    
    func checkInfo() -> Bool{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var date = dateFormatter.dateFromString(dayAndTimeField.text)
        if date == nil {
            let alertMessage = UIAlertController(title: "Fail", message: "Date & Time format is wrong! It should be MM-dd-yyyy HH:mm.", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
            return false
        }
        
        
        if categoryField.text != "Leisure" && categoryField.text != "Travel" && categoryField.text != "Arts" && categoryField.text != "Sports" && categoryField.text != "Education" {
            let alertMessage = UIAlertController(title: "Fail", message: "Category should be from Leisure, Travel, Arts, Sports, Education.", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
            return false
        }
        
        return true
        
    }
    
    func submitEventInfo(gesture: UIGestureRecognizer){
        // TODO: Submit the infomation of the event to server
        // NOTE: Remember to compress the image first!!!
        // Data: titleField.text, descriptionField.text, dateAndTimeField.text, locationField.text, imageField.image
        
        if !self.checkInfo() {
            return
        }
        
        var request = NSMutableURLRequest(URL: NSURL(string: User.URLbase + "/event/add/")!)
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
        
        let postString = "name=" + title! + "&organizor=" + User.UID + "&place=" + location! + "&description=" + description! + "&time=" + time! + "&category=" + convertCategoryID()
        
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
        return cells[indexPath.row]
    }
    
    func converTime(time: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var date = dateFormatter.dateFromString(time)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
        let dateString = dateFormatter.stringFromDate(date!)
        return dateString
    }
    
    func convertCategoryID() -> String {
        if categoryField.text != "Leisure" {
            return "2"
        }
        if categoryField.text != "Travel" {
            return "3"
        }
        if categoryField.text != "Arts" {
            return "4"
        }
        if categoryField.text != "Sports" {
            return "5"
        }
        if categoryField.text != "Education" {
            return "6"
        }
        return "2"
    }
}