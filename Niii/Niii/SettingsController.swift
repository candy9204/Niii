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
    
    var image: UIImage = UIImage()
    
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
                submitButton.addTarget(self, action: "submitUpdate:", forControlEvents: .TouchUpInside)
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
                subView.addSubview(title)
                subView.addSubview(photo)
            } else {
                let title = UILabel(frame: CGRectMake(20, 5, (sw-40)/3.0, sh-10))
                var textView:UITextView
                
                if i == 0 {
                    title.text = "Nickname:"
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
                    // Add username to User
                    textView.text = User.username
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
        image = chosenImage
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func submitUpdate(gesture: UIGestureRecognizer){
        let imageData:NSData = NSData(data: UIImageJPEGRepresentation(image, 1.0))
        SRWebClient.POST(User.URLbase + "/user/" + User.UID + "/profile/update/")
            .data(imageData, fieldName:"photo", data:["gender": gender.text, "nickname": nickName.text, "email": email.text])
            .send({(response:AnyObject!, status:Int) -> Void in
                //process success response
                
                User.nickname = self.nickName.text
                User.gender = self.gender.text
                User.photo = self.image

                },failure:{(error:NSError!) -> Void in
                    println("ERROR")
            })
        
        // Done
        let alertMessage = UIAlertController(title: "Success", message: "You have updated your info!", preferredStyle: .Alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            action in
            let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
            mainPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            mainPage.selectedIndex = self.parentController
            self.presentViewController(mainPage, animated:true, completion:nil)
        }))
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
}