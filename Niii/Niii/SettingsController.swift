//
//  SettingsController.swift
//  Niii
//
//  Created by LinShengyi on 5/20/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profile: UITableView!
    var parentController = 0
    var picker = UIImagePickerController()
    var smallRowHeight:CGFloat = 60
    var largeRowHeight:CGFloat = 150
    
    var nickName:UITextView = UITextView()
    var userName:UITextView = UITextView()
    var gender:UITextView = UITextView()
    var rating:UITextView = UITextView()
    var email:UITextView = UITextView()
    var photo:UIImageView = UIImageView()
    var submitButton:UIButton = UIButton()
    var cells:[UITableViewCell] = [UITableViewCell]()
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
        self.profile.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        createCells()
    }
    
    func createCells(){
        for var i = 0; i < 7; i++ {
            var cell:UITableViewCell = self.profile.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            let tw = self.bounds.width
            var th : CGFloat
            
            if i == 5 {
                th = largeRowHeight
            } else {
                th = smallRowHeight
            }
            
            let subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
            subView.backgroundColor = UIColor.whiteColor()
            
            let sh = subView.bounds.height
            let sw = subView.bounds.width
            
            if i == 6 {
                submitButton.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)/3.0, sh-10)
                let image = UIImage(named: "button.png")
                submitButton.setBackgroundImage(image, forState: UIControlState.Normal)
                submitButton.setTitle("Submit", forState: .Normal)
                submitButton.setTitleColor(UIColorFromHex.color(0x0075FF), forState: .Normal)
                submitButton.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 18)
                submitButton.addTarget(self, action: "submitEventInfo:", forControlEvents: .TouchUpInside)
                subView.addSubview(submitButton)
            } else if i == 5 {
                let title = UILabel(frame: CGRectMake(20, 5, (sw-40)/3.0, sh-10))
                title.text = "Photo:"
                photo.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                photo.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                photo.layer.cornerRadius = 5.0
                let selectPhotoGesture = UITapGestureRecognizer(target: self, action: "selectPhoto:")
                photo.addGestureRecognizer(selectPhotoGesture)
                photo.userInteractionEnabled = true
                subView.addSubview(photo)
            } else {
                let title = UILabel(frame: CGRectMake(20, 5, (sw-40)/3.0, sh-10))
                var textView:UITextView
                
                if i == 0 {
                    title.text = "NickName:"
                    textView = nickName
                } else if i == 1 {
                    title.text = "Gender:"
                    textView = gender
                } else if i == 2 {
                    title.text = "Rating:"
                    textView = rating
                    textView.text = User.rating
                    textView.editable = false
                    subView.addSubview(rating)
                } else if i == 3 {
                    title.text = "Email:"
                    textView = email
                } else {
                    title.text = "Username:"
                    textView = userName
                    // TODO: Add username to User
                    textView.text = "username"
                    textView.editable = false
                }
                title.font = UIFont(name: "AmericanTypewriter", size: 18)
                subView.addSubview(title)
                textView.frame = CGRectMake(20+(sw-40)/3.0, 5, (sw-40)*2/3.0, sh-10)
                textView.layer.backgroundColor = UIColorFromHex.color(0xD4E7FF).CGColor
                textView.layer.cornerRadius = 5.0
                textView.font = UIFont(name: "AlNile", size: 18)
                subView.addSubview(textView)
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
        photo.contentMode = .ScaleAspectFit //3
        photo.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    
    @IBAction func backToMe(sender: AnyObject) {
        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
        mainPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        mainPage.selectedIndex = parentController
        self.presentViewController(mainPage, animated:true, completion:nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7;
    }
    
    // Setting the height of the rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return largeRowHeight
        } else {
            return smallRowHeight
        }
    }
    
    func checkInfo() -> Bool{
        if email.text != "Leisure" && email.text != "Travel" && email.text != "Arts" && email.text != "Sports" && email.text != "Education" {
            let alertMessage = UIAlertController(title: "Fail", message: "Category should be from Leisure, Travel, Arts, Sports, Education.", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
            return false
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var date = dateFormatter.dateFromString(gender.text)
        if date == nil {
            let alertMessage = UIAlertController(title: "Fail", message: "Date & Time format is wrong! It should be MM-dd-yyyy HH:mm.", preferredStyle: .Alert)
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
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://52.25.65.141:8000/event/add/")!)
        request.HTTPMethod = "POST"
        
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString(" ")
        
        var title = nickName.text
        var location = rating.text
        var description = userName.text
        var time = self.converTime(gender.text as String) as String!
        
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
        if email.text != "Leisure" {
            return "2"
        }
        if email.text != "Travel" {
            return "3"
        }
        if email.text != "Arts" {
            return "4"
        }
        if email.text != "Sports" {
            return "5"
        }
        if email.text != "Education" {
            return "6"
        }
        return "2"
    }
}