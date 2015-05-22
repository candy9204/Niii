//
//  SingleEventController.swift
//  Niii
//
//  Created by LinShengyi on 4/30/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit
import MapKit

class SingleEventController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var eventInfo: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var mapView: MKMapView!
    let manager = CLLocationManager()
    var location = CLLocation(latitude: 40.8121195, longitude: -73.9585067)
    let searchRadius: CLLocationDistance = 1000
    var event:Event = Event()
    var parentController = 0
    var parentCall = 0
    var infoRowHeight:CGFloat = 200.0
    var participantsRowHeight:CGFloat = 100.0
    var titleRowHeight:CGFloat = 40.0
    var commentRowHeight:CGFloat = 100.0
    var descriptionRowHeight:CGFloat = 100.0
    var activityRowHeight:CGFloat = 60.0
    var isJoined: Bool = false
    var isFavorite: Bool = false
    var bounds: CGRect = UIScreen.mainScreen().bounds
    var cells:[UITableViewCell] = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.eventInfo.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.startUpdatingLocation()
        // Get event information from database
        if !self.event.updated {
            getInformationFromDatabase()
            self.event.updated = true
        }
        self.creatCells()
    }
    
    func creatCells() {
        cells = []
        for var i = 0; i < (event.comments.count + 7); i++ {
            let cell: UITableViewCell = eventInfo.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            var subView:UIView!
            let tw = self.bounds.width
            var th:CGFloat = 0
            
            if i == 0 {
                th = infoRowHeight
                
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                // Subview
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                // TODO: Add map
                let w = min(sw/2.0-25, sh-10)
                let os = (sw/2.0 - w) / 2.0
                mapView = MKMapView(frame: CGRectMake(sw/2.0+os, os, w, w))
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, self.searchRadius * 2.0, self.searchRadius * 2.0)
                mapView.setRegion(coordinateRegion, animated: false)
                
                // holder name
                let eh = (sh - 25) / 5.0
                let label1 = UILabel()
                label1.frame = CGRect(x: 20, y: 5, width: sw/2.0-25, height: eh)
                label1.text = event.holderName
                label1.font = UIFont(name: "AmericanTypewriter", size: 20)
                
                
                // rating
                let subw = min(sw/20.0, eh)
                for var i = 0; i < event.rating; i++ {
                    let image = UIImage(named: "starY.png")
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: 20+CGFloat(i)*subw, y: 10+eh, width: subw, height: subw)
                    subView.addSubview(imageView)
                }
                for var i = event.rating; i < 5; i++ {
                    let image = UIImage(named: "starN.png")
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: 20+CGFloat(i)*subw, y: 10+eh, width: subw, height: subw)
                    subView.addSubview(imageView)
                }
                
                let button = UIButton()
                let image = UIImage(named: "rating.png")
                button.setBackgroundImage(image, forState: UIControlState.Normal)
                button.frame = CGRect(x: 20+6.0*subw, y: 10+eh, width: subw, height: subw)
                
                let ratingTapGesture = UITapGestureRecognizer(target: self, action: "ratingTapGesture:")
                button.addGestureRecognizer(ratingTapGesture)
                button.userInteractionEnabled = true
                
                subView.addSubview(button)
                
                
                // address
                let label2 = UILabel()
                label2.frame = CGRect(x: 20, y: 20+2*eh, width: sw/2.0-25, height: eh)
                label2.text = event.address
                label2.font = UIFont(name: "AmericanTypewriter", size: 12)
                
                
                // date
                let label3 = UILabel()
                label3.frame = CGRect(x: 20, y: 25+3*eh, width: sw/2.0-25, height: eh)
                label3.text = event.date
                label3.font = UIFont(name: "AmericanTypewriter", size: 12)
                
                
                subView.addSubview(label1)
                subView.addSubview(label2)
                subView.addSubview(label3)
                subView.addSubview(mapView)
                if self.event.updated {
                    searchInMap(self.event.address, time: self.event.date)
                }
            
            } else if i == 1 {
                th = titleRowHeight
                
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                let label = UILabel();
                label.frame = CGRect(x: 20, y: 5, width: sw-10, height: sh-10)
                label.text = "Description:"
                label.font = UIFont(name: "AmericanTypewriter", size: 20)
                subView.addSubview(label)
                
            } else if i == 2 {
                th = descriptionRowHeight
                
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                let textView = UITextView();
                textView.frame = CGRect(x: 20, y: 5, width: sw-40, height: sh-10)
                textView.text = event.description
                textView.font = UIFont(name: "AlNile", size: 16)
                textView.editable = false
                subView.addSubview(textView)
                
            } else if i == 3 {
                th = titleRowHeight
                
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                let label = UILabel();
                label.frame = CGRect(x: 20, y: 5, width: sw-10, height: sh-10)
                label.text = "Participants:"
                label.font = UIFont(name: "AmericanTypewriter", size: 20)
                subView.addSubview(label)
                
            } else if i == 4 {
                th = participantsRowHeight
                
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                for var i = 0; i < event.followers.count; i++ {
                    let image = event.followers[i]
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: 20+CGFloat(i)*sh, y: 10, width: sh-20, height: sh-20)
                    let selectPhotoGesture = UITapGestureRecognizer(target: self, action: "showInfo:")
                    imageView.addGestureRecognizer(selectPhotoGesture)
                    imageView.userInteractionEnabled = true
                    imageView.tag = i
                    subView.addSubview(imageView)
                }
                
            } else if i == 5 {
                th = activityRowHeight
                
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                let subw = min(sh-10, (sw-40)/2.0)
                let offset = (sw - 40 - 2.0 * subw) / 3.0
                
                let like = UIButton();
                like.frame = CGRect(x: offset+20, y: 5, width: subw, height: subw)
                let image1 = UIImage(named: "like.png")
                like.setBackgroundImage(image1, forState: UIControlState.Normal)
                let likeTapGesture = UITapGestureRecognizer(target: self, action: "likeTapGesture:")
                like.addGestureRecognizer(likeTapGesture)
                like.userInteractionEnabled = true
                
                let join = UIButton();
                join.frame = CGRect(x: 2*offset+subw+20, y: 5, width: subw, height: subw)
                let image2 = UIImage(named: "go.png")
                join.setBackgroundImage(image2, forState: UIControlState.Normal)
                let joinTapGesture = UITapGestureRecognizer(target: self, action: "joinTapGesture:")
                join.addGestureRecognizer(joinTapGesture)
                join.userInteractionEnabled = true
                
                subView.addSubview(like)
                subView.addSubview(join)
                
            } else if i == 6 {
                th = titleRowHeight
                
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                
                let btw = sh-10
                
                let label = UILabel();
                label.frame = CGRect(x: 20, y: 5, width: sw-btw-40, height: sh-10)
                label.text = "Comments:"
                label.font = UIFont(name: "AmericanTypewriter", size: 20)
                
                let add = UIButton()
                let image = UIImage(named: "addred.png")
                add.setBackgroundImage(image, forState: UIControlState.Normal)
                add.frame = CGRect(x: sw-btw-20, y: 5, width: btw, height: btw)
                
                let addTapGesture = UITapGestureRecognizer(target: self, action: "addTapGesture:")
                add.addGestureRecognizer(addTapGesture)
                add.userInteractionEnabled = true
                
                subView.addSubview(add)
                subView.addSubview(label)
                
            } else {
                th = commentRowHeight
                
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView = UIView(frame: CGRectMake(0, 0, tw, th-5))
                subView.backgroundColor = UIColor.whiteColor()
                
                let sh = subView.bounds.height
                let sw = subView.bounds.width
                let subh = (sh - 10) / 2.0
                
                let comment = event.comments[i-7]
                let label_name = UILabel()
                label_name.frame = CGRect(x: 20, y: 5, width: (sw-10)/2.0, height: subh)
                label_name.text = comment[0] + ":"
                label_name.font = UIFont(name:"AmericanTypewriter", size: 16.0)
                
                let label_time = UILabel()
                label_time.text = comment[1]
                label_time.frame = CGRect(x: 20+(sw-10)/2.0, y: 5, width: (sw-10)/2.0, height: subh)
                label_time.font = UIFont(name:"AmericanTypewriter", size: 10.0)
                
                let content = UITextView()
                content.text = comment[2]
                content.frame = CGRect(x: 20, y: 5+subh, width: sw-40, height: subh)
                content.font = UIFont(name: "AlNile", size: 16)
                content.editable = false
                
                subView.addSubview(label_name)
                subView.addSubview(label_time)
                subView.addSubview(content)
            }
            
            cell.backgroundColor = UIColor.clearColor();
            cell.contentView.addSubview(subView)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cells.append(cell)
        }

    }
    
    func showInfo(gesture: UIGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            // TODO: Show information of the participant
            println("Clicked")
            // User imageView.tag to learn which imageView is clicked
            println(imageView.tag)
        }
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackToEvents(sender: AnyObject) {
        if self.parentController <= 3 {
            let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as! UITabBarController
            mainPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            mainPage.selectedIndex = parentController
            self.presentViewController(mainPage, animated:true, completion:nil)
        } else {
            let fAndHListPage = self.storyboard?.instantiateViewControllerWithIdentifier("fAndHListPage") as! FAndHListController
            fAndHListPage.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            fAndHListPage.parentController = 3
            fAndHListPage.parentCall = self.parentCall
            self.presentViewController(fAndHListPage, animated:true, completion:nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.comments.count + 7;
        //println("cell #: " + String(indexPath.row))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func ratingTapGesture(gesture: UIGestureRecognizer) {
        let alertController = UIAlertController(title: "Rating", message:
            "Please rate the event ~\\^O^/~ \n(Awful: 1 -> 2 -> 3 -> 4-> 5 :Wonderful)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default, handler: {
            action in
            let ratingTextField = alertController.textFields![0] as! UITextField
            let rating = ratingTextField.text.toInt()
            // TODO: Submit the rating to server
            
            self.ratingHolder(rating!)
            
            // Done
            let alertMessage = UIAlertController(title: "Success", message: "You have submitted the rating for this event!", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
        submitAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Rating"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                submitAction.enabled = (!textField.text.isEmpty && textField.text.toInt() <= 5 && textField.text.toInt() >= 0)
                
            }
        }
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addTapGesture(gesture: UIGestureRecognizer) {
        let alertController = UIAlertController(title: "Add Comment", message:
            "Add your comment for this event ~\\^O^/~", preferredStyle: UIAlertControllerStyle.Alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default, handler: {
            action in
            let commentTextField = alertController.textFields![0] as! UITextField
            let comment = commentTextField.text
            // TODO: Submit the new comment to server
            
            self.AddComment(comment)
            
            // Done
            let alertMessage = UIAlertController(title: "Success", message: "You have submitted the comment for this event!", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                action in
                
                self.creatCells()
                self.eventInfo.reloadData()
            }))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
        submitAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Comment"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                submitAction.enabled = !textField.text.isEmpty
            }
        }
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func likeTapGesture(gesture: UIGestureRecognizer) {
        let alertController = UIAlertController(title: "Favorite Event", message:
            "Are you sure to favorite this event?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let joinAction = UIAlertAction(title: "Favorite", style: .Default, handler: {
            action in
            // TODO: Send the "favorite" message to server
            
            self.favoriteEvent()
            
            // Done
            let alertMessage = UIAlertController(title: "Success", message: "You have favorited this event!", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
        
        alertController.addAction(joinAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func joinTapGesture(gesture: UIGestureRecognizer) {
        var joinTitle = "Join In Event"
        var joinMessage = "Are you sure to join in this event?"
        var button = "join"
        var successMsg = "You have joined in this event!"
        
        if self.isJoined {
            joinTitle = "Unjoin Event"
            joinMessage = "You have already joined in this event. Are you sure to unjoin this event?"
            button = "unjoin"
            successMsg = "You have unjoined this event!"
        }
        let alertController = UIAlertController(title: joinTitle, message: joinMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let joinAction = UIAlertAction(title: button, style: .Default, handler: {
            action in
            // TODO: Send the "join in" message to server
            
            self.joinEvent(button)
            
            // Done
            let alertMessage = UIAlertController(title: "Success", message: successMsg, preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
        
        alertController.addAction(joinAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Setting the height of the rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return infoRowHeight
        } else if indexPath.row == 1 {
            return titleRowHeight
        } else if indexPath.row == 2 {
            return descriptionRowHeight
        } else if indexPath.row == 3 {
            return titleRowHeight
        } else if indexPath.row == 4 {
            return participantsRowHeight
        } else if indexPath.row == 5 {
            return activityRowHeight
        } else if indexPath.row == 6 {
            return titleRowHeight
        } else {
            return commentRowHeight
        }
    }
    
    func getInformationFromDatabase(){
        // TODO: Get information from database
        let urlPath = User.URLbase + "/event/" + User.eventID + "/?user_id=" + User.UID
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
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
            
            let eventName = jsonResult["name"] as! String
            let address = jsonResult["place"] as! String
            let dateString = self.timeToString(jsonResult["time"] as! String)
            
            let description = jsonResult["description"] as! String
            let organizor = jsonResult["organizor"] as! NSDictionary
            let holderName = organizor["nickname"] as! String
            
            let holderID = String(organizor["id"] as! Int)
            let parts = jsonResult["participants"] as! NSArray

            let pCount = parts.count
            var r = organizor["rating"] as? Int
            var rating = 0
            if r != nil {
                rating = r!
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.isJoined = jsonResult["is_joined"] as! Bool
                self.isFavorite = jsonResult["is_favorited"] as! Bool
                self.event.eventName = eventName
                self.event.holderName = holderName
                self.event.holderID = holderID
                self.event.address = address

                for var i = 0; i < pCount; i++ {
                    
                    self.event.followers.append(UIImage(named:"head.jpg")!)
                    let photoURL = parts[i]["photo"] as? String
                    if let url = photoURL {
                        let urlString = User.URLbase + url  //User.URLbase + url
                        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: urlString)!)
                        let mainQueue = NSOperationQueue.mainQueue()
                        let fow = i
                        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                            if error == nil {
                                dispatch_async(dispatch_get_main_queue(), {
                                    let image = UIImage(data: data)
                                    if fow < self.event.followers.count && image != nil  {
                                        println("TEST")
                                        self.self.event.followers[fow] = image!
                                        self.creatCells()
                                        self.eventInfo.reloadData()
                                    }
                                })
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                        })
                    }

                }
                
                self.updateComments()
                
                self.event.rating = rating
                self.event.description = description
                self.event.date = dateString
                var title:String = self.event.eventName
                if count(self.event.eventName) > 20 {
                    title = (title as NSString).substringToIndex(18) + "..."
                }
                self.titleLabel.text = title
                
                
                self.searchInMap(address, time: dateString)
                self.mapView.reloadInputViews()
                self.creatCells()
                self.eventInfo.reloadData()
                self.titleLabel.reloadInputViews()
                
            })
        })
        task.resume()
        
    }
    
    func updateComments() {
        var request = NSMutableURLRequest(URL: NSURL(string: User.URLbase + "/event/" + User.eventID + "/comments/")!)
        request.HTTPMethod = "POST"
        
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
            
            let comments = jsonResult["comments"] as! NSArray
            
            dispatch_async(dispatch_get_main_queue(), {
                for comment in comments {
                    let content = comment["content"] as! String
                    let user = comment["user"] as! NSDictionary
                    let username = user["nickname"] as! String
                    let dateString = self.timeToString(comment["time"] as! String)
                    
                    self.event.comments.append([username, dateString, content])
                }
                self.creatCells()
                self.eventInfo.reloadData()
            })
        }
        task.resume()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil {
                println("ERROR: " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.location = manager.location
                self.manager.stopUpdatingLocation()
                
            } else {
                self.location = manager.location
            }
        })
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("ERROR!!!")
    }
    
    func searchInMap(address: String, time: String) {

        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address

        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: location.coordinate, span: span)

        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler {
            (response: MKLocalSearchResponse!, error: NSError!) in
            
            if response != nil {
                for item in response.mapItems as! [MKMapItem] {
                    self.addPinToMapView(item.name, subtitle: time, latitude: item.placemark.location.coordinate.latitude, longitude: item.placemark.location.coordinate.longitude)
                    break
                }
            } else {
                
            }
        }
    }
    
    func addPinToMapView(title: String, subtitle: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MyAnnotation(coordinate: location, title: title, subtitle: subtitle)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000.0, 2000.0)
        mapView.setRegion(region, animated: false)
        mapView.addAnnotation(annotation)
    }
    
    func timeToString(time: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ssxxx"
        var date = dateFormatter.dateFromString(time)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ss.SSSxxx"
            date = dateFormatter.dateFromString(time)
        }
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        let dateString = dateFormatter.stringFromDate(date!)
        return dateString
    }
    
    func AddComment(comment: String) {
        self.updateUserInfo(comment)
        
        var request = NSMutableURLRequest(URL: NSURL(string: User.URLbase + "/event/" + User.eventID + "/comments/add/")!)
        request.HTTPMethod = "POST"
        
        let postString = "user_id=" + User.UID + "&content=" + comment
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
    }
    
    func updateUserInfo(comment: String) {
        let content = comment
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        let dateString = dateFormatter.stringFromDate(NSDate())
        
        if !User.updated {
            var request = NSMutableURLRequest(URL: NSURL(string: User.URLbase + "/user/" + User.UID + "/profile/")!)
            request.HTTPMethod = "POST"
            
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
                
                //println(jsonResult)
                
                let nickname = jsonResult["nickname"] as! String
                let g = jsonResult["gender"] as? Int
                let gender: String
                if g == 1 {
                    gender = "Male"
                } else {
                    gender = "Female"
                }
                let rating = jsonResult["rating"] as? String
                //println(nickname)
                dispatch_async(dispatch_get_main_queue(), {
                    User.nickname = nickname
                    User.gender = gender as String!
                    if rating != nil {
                        User.rating = rating as String!
                    }
                    User.updated = true
                    
                    self.event.comments.append([nickname, dateString, content])
                    self.creatCells()
                    self.eventInfo.reloadData()
                })
            }
            task.resume()
        } else {
            self.event.comments.append([User.nickname, dateString, content])
        }

    }
    
    func ratingHolder(rating: Int) {
        
        var request = NSMutableURLRequest(URL: NSURL(string: User.URLbase + "/user/" + self.event.holderID + "/rate/")!)
        request.HTTPMethod = "POST"
        let postString = "ratee_id=" + User.UID + "&score=" + String(rating)
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
            
            //println(jsonResult)
            
        }
        task.resume()

    }
    
    func favoriteEvent() {
        
        let urlPath = User.URLbase + "/event/" + User.eventID + "/favorite/?user_id=" + User.UID
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
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
            
            //println(jsonResult)
            
        })
        task.resume()
        
    }
    
    func joinEvent(join: String) {
        let urlPath = User.URLbase + "/event/" + User.eventID + "/" + join + "/?user_id=" + User.UID
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
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
            
            //println(jsonResult)
            
        })
        task.resume()
        
    }
}