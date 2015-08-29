
//
//  WriteCommentViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/10/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation


class WriteCommentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UIScrollViewDelegate{
    
    let locationManager = CLLocationManager()
    var fakeHashtags = ["#CounterCulture","#Bicycle","#Motorcycle","#Plane","#Train","#Car","#Scooter","#CounterCulture","#Bicycle","#Motorcycle","#Plane","#Train","#Car","#Scooter"]
    @IBOutlet var hashtagScrollHolder:UIScrollView!
    @IBOutlet var everythingScrollHolder:UIScrollView!
    @IBOutlet var scrollContentView:UIView!
    @IBOutlet var scrollContentViewHeightConnstraint:NSLayoutConstraint!
    @IBOutlet var everythingScrollHolderBottomConstraint:NSLayoutConstraint!
    @IBOutlet var hashtagHolderHeightConstraint:NSLayoutConstraint!
    @IBOutlet var postHolderView:UIView!
    @IBOutlet var continueLabel: UILabel!
    @IBOutlet var charNumLabel: UILabel!
    @IBOutlet var postButton:UIButton!
    @IBOutlet var separatorView:UIView!
    @IBOutlet var backButton:UIBarButtonItem!
    @IBOutlet var navigationBar:UINavigationBar!
    @IBOutlet var navBar:UINavigationItem!
    
    var testString = "1"
    var comment = "empty"
    var authorID = "empty"
    var commingFrom = "none"
    var hasStartedPost = false
    
    var sentLocation = "none"
    var maxStringLength = 200;
    var hashtagJSON: NSDictionary!
    
    @IBOutlet var commentView: UITextView!
    
    @IBOutlet var oimageView: UIImageView!
    
    
    // @IBOutlet var cameraBut:UIImageView!
    @IBOutlet var cameraBLabel:UILabel!
    //@IBOutlet var chooseBut:UIImageView!
    @IBOutlet var chooseBLabel:UILabel!
    
    var imagePicker: UIImagePickerController!
    
    var hasImage = false
    
    var savedImage: UIImage!
    
    var imageLink = "none"
    //  var captureDeviceBack : AVCaptureDevice?
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    var hashtagButtons = [UIButton?]()
    var hashtagIdIndex = [String: Int]()
    var hashtagSelectedIndex = [Int : Bool]()
    var widthFiller = 0
    var scrollHolderWidth = 350
    var yPos = 10.0
    var hasStartedClick = false
    var isScrolling = false
    var hasSelectedAHashtag = false
    
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        self.getUserHashtags()
        self.hasStartedPost = false
        
        self.hashtagScrollHolder.delegate = self
        self.everythingScrollHolder.delegate = self
        self.everythingScrollHolder.frame = self.view.frame
        self.everythingScrollHolder.contentSize = self.view.frame.size
        
        self.postHolderView.layer.cornerRadius = 10.0;
        self.postHolderView.layer.masksToBounds = true;
        
        self.separatorView.layer.cornerRadius = 4.0
        self.separatorView.layer.masksToBounds = true
        
        
        self.view.backgroundColor = UIColor(red: (255.0/255.0), green: (210.0/255.0), blue: (11.0/255.0), alpha: 1.0)
        self.locationManager.delegate = self
        
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.startUpdatingLocation()
        // self.locationManager.distanceFilter = 3
        
        
        //  let tracker = GAI.sharedInstance().defaultTracker
        //  tracker.set(kGAIScreenName, value: "/index")
        //  tracker.send(GAIDictionaryBuilder.createScreenView().build())
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Write Comment Scene", action: "Show Scene", label: "Showed", value: nil).build() as [NSObject : AnyObject])
        
        //  self.commentView.becomeFirstResponder()
        
        
        //  scrollView.contentSize = CGSizeMake(400, 2300)
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id")
        self.authorID = fbid!
        
        
        
        
        
        commentView.text = "What's the Buzz?"
        commentView.textColor = UIColor.lightGrayColor()
        commentView.delegate = self
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        
        //        buttonHolder.layer.borderWidth=2.0
        //                buttonHolder.layer.masksToBounds = false
        //                buttonHolder.layer.borderColor = color.CGColor//UIColor.blackColor().CGColor
        //
        //                //profilePic.layer.cornerRadius = 13
        //                buttonHolder.clipsToBounds = true
        //
        //        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //        let writeView = mainStoryboard.instantiateViewControllerWithIdentifier("pick_hashtags_id") as! pickHashtagsInitialViewController
        //
        //
        //         writeView.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
        if(self.commingFrom == "pickHashtags"){
            self.continueLabel.userInteractionEnabled = true
            let imageTap = UITapGestureRecognizer(target: self, action:Selector("continueWithoutPosting"))
            // 4
            imageTap.delegate = self
            self.continueLabel.addGestureRecognizer(imageTap)

        }
        else{
            self.navBar.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIcon.png"), style: UIBarButtonItemStyle.Plain, target: self, action:"did_press_cancel")
            self.continueLabel.removeFromSuperview()
        }
    }
    
    func continueWithoutPosting(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let fbView = mainStoryboard.instantiateViewControllerWithIdentifier("main_tab_bar_scene_id") as! UITabBarController
        
      // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(fbView, animated: false, completion: nil)
        
        
    }
    
    func getUserHashtags(){
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_user_get_hashtags")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        var params = ["fb_id":fbid, "gfb_id":fbid] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            
            
            //self.theJSON = NSJSONSerialization.JSONObjectWithData(json, options:.MutableLeaves, error: &err) as? NSDictionary
            
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                
            }
            else {
                
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                
                
                
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    let infoJSON = parseJSON as NSDictionary
                    self.hashtagJSON = json
                    
                    self.fakeHashtags.removeAll(keepCapacity: false)
                    dispatch_async(dispatch_get_main_queue(), {
                        for j in 0...(infoJSON["results"]!.count - 1){
                            self.fakeHashtags.append(infoJSON["results"]![j]["body"] as! String)
                        }
                        self.showUserHashtags()
                    })
                    //
                    
                    
                    //   self.reload_table()
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    //   self.showErrorScreen("top")
                }
            }
        })
        task.resume()
        //END AJAX
        
        

       
    }
    
    func showUserHashtags(){
        
        for i in 0...(self.fakeHashtags.count - 1){
            var daID = self.hashtagJSON["results"]![i]["id"] as! NSString
            let daID2 = daID.integerValue
            self.createHashtag(self.fakeHashtags[i], id: daID2);
        }
        self.createHashtag("Add New", id: -1)
        if(hashtagButtons.count > 0){
            let holder = hashtagButtons.last! as UIButton!
            let height = Double(holder.frame.origin.y) + Double(holder.frame.height) + 20.0;
            let hashHeight = Double(hashtagHolderHeightConstraint.constant)
            if(height < hashHeight){
                self.hashtagHolderHeightConstraint.constant = CGFloat(height)
            }
            else{
                self.hashtagScrollHolder.contentSize = CGSize(width: Double(self.hashtagScrollHolder.contentSize.width), height: height)
            }
            
        }
    }
    func createHashtag(title: NSString, id:NSInteger){
        //let width = Int(title.length)*12
        println("THE WiDTH\(self.hashtagScrollHolder.frame.width)")
        var title = title as String
        let f = UIFont(name: "Lato-Light", size: 23.0)
        let width = Int(title.sizeWithAttributes([NSFontAttributeName: f!]).width) + 15
        let height = Int(title.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(24.0)]).height) + 15
        var xpos = 5.0
        var widthSpacing = 12.0
        if(hashtagButtons.count > 0){
            let holder = hashtagButtons.last! as UIButton!
            xpos = Double(holder.frame.origin.x) + Double(holder.frame.width) + widthSpacing;
        }
        
        let testWidthFiller = self.widthFiller + width + Int(widthSpacing)
        //self.widthFiller += width + Int(widthSpacing)
        
        if(Int(testWidthFiller) > Int(scrollHolderWidth)){
            self.widthFiller = width + Int(widthSpacing)
            self.yPos += Double(height) + 12.0
            xpos = 5.0
        }
        else{
            self.widthFiller = testWidthFiller
        }
        
        var newButton = UIButton(frame: CGRect(x: Int(xpos), y: Int(yPos), width: width, height: height))
        newButton.backgroundColor = UIColor(red: (255.0/255.0), green: (165.0/255.0), blue: (0.0/255.0), alpha: 1.0)
        
        newButton.setTitle(title as String, forState: UIControlState.Normal)
        newButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 24.0)
        
        self.hashtagScrollHolder.addSubview(newButton)
        self.hashtagButtons.append(newButton)
        
        if(id != -1){
            newButton.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchDown)
            newButton.addTarget(self, action: "unpressed:", forControlEvents: UIControlEvents.TouchDragExit)
            newButton.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchDragEnter)
            newButton.addTarget(self, action: "selected:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        else{
            newButton.addTarget(self, action: "didPressAddNew", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.hashtagIdIndex[title] = id
        self.hashtagSelectedIndex[id] = false
        
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(decelerate == false){
            self.isScrolling = false
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //self.isScrolling = false
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.isScrolling = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollViewHeight = scrollView.frame.size.height;
        var scrollContentSizeHeight = scrollView.contentSize.height;
        var scrollOffset = scrollView.contentOffset.y;
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.5 * Double(NSEC_PER_SEC)))
        
        self.isScrolling = true
        
        if (scrollOffset < 0)
        {
            self.isScrolling = true
        }
        else if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight)
        {
            self.isScrolling = true
        }
    }
    
    
    
    
    func pressed(dabut: UIButton){
        
        if(self.isScrolling == false){
            
            hasStartedClick = false
            let time1 = 0.1
            let startingWidth = dabut.frame.width
            let startingHeight = dabut.frame.height
            let startingX = dabut.frame.origin.x
            let startingY = dabut.frame.origin.y
            let wChanger = CGFloat(5.0)
            let hChanger = CGFloat(10.0)
            let wChanger2 = CGFloat(3.0)
            let hChanger2 = CGFloat(6.0)
            
            UIView.animateWithDuration(time1, delay: 0.0, options: .CurveEaseOut, animations: {
                
                dabut.frame = CGRect(x: startingX - wChanger/2.0, y: startingY - hChanger/2.0, width: startingWidth + wChanger, height: startingHeight + hChanger)
                //dabut.titleLabel!.transform = CGAffineTransformScale(dabut.titleLabel!.transform, 1.1, 1.1);
                //dabut.titleLabel!.center = CGPoint(x: dabut.titleLabel!.center.x + wChanger, y: dabut.titleLabel!.center.y + hChanger);
                dabut.titleLabel?.font = UIFont(name: "Lato-Regular", size: 26.0)
                
                }, completion: { finished in
                    
            })
            
        }
        
        
    }
    
    func unpressed(dabut: UIButton){
        
        
        
        let time1 = 0.1
        
        
        let wChanger = CGFloat(5.0)
        let hChanger = CGFloat(10.0)
        let wChanger2 = CGFloat(3.0)
        let hChanger2 = CGFloat(6.0)
        let startingWidth = dabut.frame.width - wChanger
        let startingHeight = dabut.frame.height - hChanger
        let startingX = dabut.frame.origin.x + wChanger/2.0
        let startingY = dabut.frame.origin.y + hChanger/2.0
        
        if(self.isScrolling == false){
            hasStartedClick = false
            UIView.animateWithDuration(time1, delay: time1, options: .CurveEaseOut, animations: {
                
                dabut.frame = CGRect(x: startingX + (wChanger + wChanger2)/2.0, y: startingY + (hChanger + hChanger2)/2.0, width: startingWidth - wChanger - wChanger2, height: startingHeight - hChanger - hChanger2)
                dabut.titleLabel?.font = UIFont(name: "Lato-Light", size: 20.0)
                
                }, completion: { finished in
                    
            })
            UIView.animateWithDuration(time1, delay: time1*2, options: .CurveEaseOut, animations: {
                
                dabut.frame = CGRect(x: startingX, y: startingY, width: startingWidth, height: startingHeight)
                dabut.titleLabel?.font = UIFont(name: "Lato-Light", size: 24.0)
                
                }, completion: { finished in
                    
            })
            
        }
    }
    
    func selected(dabut: UIButton){
        
        let time1 = 0.1
        
        
        let wChanger = CGFloat(5.0)
        let hChanger = CGFloat(10.0)
        let wChanger2 = CGFloat(3.0)
        let hChanger2 = CGFloat(6.0)
        let startingWidth = dabut.frame.width - wChanger
        let startingHeight = dabut.frame.height - hChanger
        let startingX = dabut.frame.origin.x + wChanger/2.0
        let startingY = dabut.frame.origin.y + hChanger/2.0
        if(self.isScrolling == false){
            if(hasStartedClick == false){
                hasStartedClick = true
                
                UIView.animateWithDuration(time1, delay: time1, options: .CurveEaseOut, animations: {
                    
                    dabut.frame = CGRect(x: startingX + (wChanger + wChanger2)/2.0, y: startingY + (hChanger + hChanger2)/2.0, width: startingWidth - wChanger - wChanger2, height: startingHeight - hChanger - hChanger2)
                    dabut.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20.0)
                    
                    }, completion: { finished in
                        
                })
                UIView.animateWithDuration(time1, delay: time1*2, options: .CurveEaseOut, animations: {
                    
                    dabut.frame = CGRect(x: startingX, y: startingY, width: startingWidth, height: startingHeight)
                    dabut.titleLabel?.font = UIFont(name: "Lato-Regular", size: 24.0)
                    
                    }, completion: { finished in
                        
                })
                
                hasStartedClick = false
                self.selectedCode(dabut)
            }
            
            
        }
    }
    
    func selectedCode(dabut: UIButton){
        
        
        let hashtagID = self.hashtagIdIndex[dabut.titleLabel!.text!]
        let isSelected = self.hashtagSelectedIndex[hashtagID!]
        println("Hashtag is false:\(isSelected)")
        if(isSelected == false){
            self.hashtagSelectedIndex[hashtagID!] = true
            self.makeHashtagSelected(dabut)
            hasSelectedAHashtag = true
        }
        else{
            self.hashtagSelectedIndex[hashtagID!] = false
            self.makeHashtagunSelected(dabut)
        }
        
        
    }
    
    func didPressAddNew(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let hashView = mainStoryboard.instantiateViewControllerWithIdentifier("pick_hashtags_id") as! pickHashtagsInitialViewController
        hashView.commingFrom = "writeView"
        self.presentViewController(hashView, animated: true, completion: nil)
        
    }
    
    
    func makeHashtagunSelected(hashtag:UIButton){
        hashtag.titleLabel?.font = UIFont(name: "Lato-Light", size: 24.0)
        hashtag.backgroundColor = UIColor(red: (255.0/255.0), green: (165.0/255.0), blue: (0.0/255.0), alpha: 1.0)
        
        var isOneHashtagTrue = false
        for i in 0...(self.fakeHashtags.count - 1){
            let hashId = self.hashtagIdIndex[self.fakeHashtags[i]]
            if(self.hashtagSelectedIndex[hashId!] == true){
                isOneHashtagTrue = true
            }
        }
        self.hasSelectedAHashtag = isOneHashtagTrue
        if(self.hasSelectedAHashtag == false){
            if(self.commentView.isFirstResponder() == true){
                self.commentView.resignFirstResponder()
                self.commentView.text = "What's the Buzz?"
                self.commentView.textColor = UIColor.lightGrayColor()
            }
        }
        
    }
    
    func makeHashtagSelected(hashtag:UIButton){
        hashtag.backgroundColor = UIColor(red: (255.0/255.0), green: (119.0/255.0), blue: (0.0/255.0), alpha: 1.0);7
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        let newString = textView.text as NSString!
        var newLength = newString.length
        if(newLength > maxStringLength){
            let retString = newString.substringWithRange(NSRange(location: 0, length: maxStringLength))
            textView.text = retString
            newLength = maxStringLength
            //return false
        }
        self.charNumLabel.text = "\(newLength)/\(maxStringLength)"
        
        return true
    }
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if (self.hasSelectedAHashtag == true){
            if(self.hasStartedPost == false){
                textView.text = nil
                self.hasStartedPost = true
            }
            else{
                
            }
            textView.textColor = UIColor.blackColor()
            return true
        }
        else{
            var alert = UIAlertController(title: "Select A Hashtag", message: "Please select a hashtag before writing a post", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Write Comment Scene", action: "Start Comment", label: "Did Begin Editing", value: nil).build() as [NSObject : AnyObject])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        //        let height2 = commentView.frame.height + oimageView.frame.height + buttonHolder.frame.height
        //        scrollView.contentSize = CGSize(width:scrollView.frame.width, height:height2)
        //
        println("THIS IS THE SENT LOCATION:\(sentLocation)")
        
        
        
        
        //        oimageView.userInteractionEnabled = true
        //        oimageView.addGestureRecognizer(imageTap)
        // scrollView.bringSubviewToFront(oimageView)
        
        let imageTap = UITapGestureRecognizer(target: self, action:Selector("clickImage:"))
        // 4
        imageTap.delegate = self
        //        cameraBut.userInteractionEnabled = true
        //        cameraBut.addGestureRecognizer(imageTap)
        //
        cameraBLabel.userInteractionEnabled = true
        cameraBLabel.addGestureRecognizer(imageTap)
        
        
        let rollTap = UITapGestureRecognizer(target: self, action:Selector("clickRoll:"))
        // 4
        rollTap.delegate = self
        //  chooseBut.userInteractionEnabled = true
        //  chooseBut.addGestureRecognizer(rollTap)
        
        chooseBLabel.userInteractionEnabled = true
        chooseBLabel.addGestureRecognizer(rollTap)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        // let imageView:UIImageView!
        //let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        
        savedImage = imageWithImage(image!, scaledToSize: CGSizeMake(300, 300))
        
        oimageView.image = savedImage
        hasImage = true
        
    }
    
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func clickImage(sender: UIGestureRecognizer){
        if(self.hasSelectedAHashtag == false){
            var alert = UIAlertController(title: "Select A Hashtag", message: "Please select a hashtag before choosing a picture", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            println("CLICK CLICK CLICK")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                println("Button capture")
                
                imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                //imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                //imagePicker.mediaTypes = [kUTTypeImage]
                imagePicker.mediaTypes = [kUTTypeImage]
                imagePicker.allowsEditing = true
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        
    }
    @IBAction func cameraButton(){
        if(self.hasSelectedAHashtag == false){
            var alert = UIAlertController(title: "Select A Hashtag", message: "Please select a hashtag before choosing a picture", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
        println("CLICK CLICK CLICK")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            println("Button capture")
            
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            //imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            //imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        }
        
        
    }
    
    
    func clickRoll(sender: UIGestureRecognizer){
        if(self.hasSelectedAHashtag == false){
            var alert = UIAlertController(title: "Select A Hashtag", message: "Please select a hashtag before choosing a picture", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            println("ROLLING ROLLING ROLLING")
            /// if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            println("Button capture")
            
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            // imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            //imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            //}
        }
        
    }
    @IBAction func rollButton(){
        
        if(self.hasSelectedAHashtag == false){
            var alert = UIAlertController(title: "Select A Hashtag", message: "Please select a hashtag before choosing a picture", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
        println("ROLLING ROLLING ROLLING")
        /// if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
        println("Button capture")
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        // imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        //imagePicker.mediaTypes = [kUTTypeImage]
        imagePicker.mediaTypes = [kUTTypeImage]
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        //}
        }
        
    }
    
    
    
    //    @IBAction func showCamera(){
    //        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
    //            println("Button capture")
    //
    //            imagePicker = UIImagePickerController()
    //            imagePicker.delegate = self
    //            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
    //            imagePicker.mediaTypes = [kUTTypeImage]
    //            imagePicker.allowsEditing = true
    //
    //            self.presentViewController(imagePicker, animated: true, completion: nil)
    //        }
    //
    //    }
    //
    
    func clickChoosePhoto(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func did_press_cancel(){
        
        self.commentView.resignFirstResponder()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Write Comment Scene", action: "End Scene", label: "Canceled", value: nil).build() as [NSObject : AnyObject])
        
    }
    
    @IBAction func did_submit_comment(){
        
        
        if(commentView.text == "What's the Buzz?"){
            commentView.text = ""
        }
        if(hasImage == true){
            
            dispatch_async(dispatch_get_main_queue(),{
                
                
                self.commentView.resignFirstResponder()
                self.showLoadingScreen()
                self.upload_picture()
                var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Write Comment Scene", action: "Send Comment", label: "Picture", value: nil).build() as [NSObject : AnyObject])
                
            })
        }
        else{
            dispatch_async(dispatch_get_main_queue(),{
                if(self.commentView.text == ""){
                    
                    
                    let alertController = UIAlertController(title: "No Content", message:
                        "Please enter text or a pic to submit", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "For Sure", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                else{
                    self.commentView.resignFirstResponder()
                    self.showLoadingScreen()
                    self.upload_comment()
                    var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("Write Comment Scene", action: "Send Comment", label: "No Picture", value: nil).build() as [NSObject : AnyObject])
                }
                
            })
        }
        
    }
    
    
    
    
    func showLoadingScreen(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let w = screenSize.width * 0.8
        let h = w * 0.283
        let squareSize = screenSize.width * 0.2
        let xPos = screenSize.width/2 - w/2
        let yPos = screenSize.height/2 - h/2
        
        let holdView = UIView(frame: CGRect(x: xPos, y: yPos, width: w, height: h))
        holdView.backgroundColor = UIColor.whiteColor()
        holdView.tag = 999
        
        holdView.layer.borderWidth=1.0
        holdView.layer.masksToBounds = false
        holdView.layer.borderColor = UIColor.clearColor().CGColor
        //profilePic.layer.cornerRadius = 13
        holdView.layer.cornerRadius = holdView.frame.size.height/10
        holdView.clipsToBounds = true
        
        view.addSubview(holdView)
        
        
        
        
        
        
        var label = UILabel(frame: CGRectMake(0, 0, holdView.frame.width, holdView.frame.height*0.2))
        label.textAlignment = NSTextAlignment.Center
        label.text = "Uploading Comment"
        //holdView.addSubview(label)
        
        
        
        
        // Returns an animated UIImage
        var url = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
        var imageData = NSData(contentsOfURL: url!)
        
        
        let image = UIImage.animatedImageWithData(imageData!)//UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let smallerSquareSize = squareSize*0.6
        let gPos = (holdView.frame.width*0.2)/2
        let kPos = (holdView.frame.height*0.2)/2
        
        
        imageView.frame = CGRect(x: gPos, y: kPos, width: w*0.8, height: h*0.8)
        holdView.addSubview(imageView)
        
    }
    
    
    
    func removeLoadingScreen(){
        //self.loadingScreen.alpha = 0.0
        
        for view in self.view.subviews {
            if(view.tag == 999){
                view.removeFromSuperview()
            }
        }
    }
    
    
    
    func upload_picture(){
        
        println("start uploading picture")
        var clientID = "cc30bb4b283f1b4"
        
        var title = "title"
        var description = "desc"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        //__weak MLViewController *weakSelf = self;
        weak var weakSelf: WriteCommentViewController? = self
        
        
        // Load the image data up in the background so we don't block the UI
        //var image: UIImage = UIImage(named:"laptop-classroom-1.jpg")
        //var image : UIImage = UIImage(named:"laptop-classroom-1.jpg")!
        //let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let image = self.savedImage// self.sendImg
        var imageData: NSData = UIImageJPEGRepresentation(image, 0.50)
        
        var requestBody: NSMutableData = NSMutableData()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        //var urlString = "https://api.imgur.com/3/upload.json"
        let url = NSURL(string: "https://api.imgur.com/3/upload.json")
        
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        request.addValue("multipart/form-data; boundary=---------------------------0983745982375409872438752038475287", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID cc30bb4b283f1b4", forHTTPHeaderField: "Authorization")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let foo = "-----------------------------0983745982375409872438752038475287\r\n"
        var data = foo.dataUsingEncoding(NSUTF8StringEncoding)
        requestBody.appendData(data!)
        
        //Content-Disposition: attachment; name=\"image\"; filename=\".tiff\"\r\n
        
        let foo2 = "Content-Disposition: attachment; name=\"image\"; filename=\".tiff\"\r\n"
        var data2 = foo2.dataUsingEncoding(NSUTF8StringEncoding)
        requestBody.appendData(data2!)
        
        let foo3 = "Content-Type: application/octet-stream\r\n\r\n"
        var data3 = foo3.dataUsingEncoding(NSUTF8StringEncoding)
        requestBody.appendData(data3!)
        
        requestBody.appendData(imageData)
        
        let foo4 = "\r\n"
        var data4 = foo4.dataUsingEncoding(NSUTF8StringEncoding)
        requestBody.appendData(data4!)
        
        let foo5 = "-----------------------------0983745982375409872438752038475287--\r\n"
        var data5 = foo5.dataUsingEncoding(NSUTF8StringEncoding)
        requestBody.appendData(data5!)
        
        request.HTTPBody = requestBody
        println("start uploading picture")
        
        //check if we need to submit comment
        var doIt = false
        dispatch_async(dispatch_get_main_queue(),{
            
            
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                println("Response: \(response)")
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Body: \(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                
                println("start uploading picture")
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: '\(jsonStr)'")
                    println("start uploading picture")
                }
                else {
                    println("start uploading picture")
                    // The JSONObjectWithData constructor didn't return an error. But, we should still
                    if let parseJSON = json {
                        
                        
                        var test = parseJSON["data"]!["link"] as? String
                        println(test!)
                        self.imageLink = test!
                        
                        doIt = true
                        
                        self.upload_comment()
                        
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        //self.theJSON = parseJSON
                        //var success = parseJSON["results"]![0]["hearts"] as? String
                        //println("Succes: \(success)")
                        //self.hearts[0] = parseJSON["results"]![0]["hearts"]
                    }
                    
                    
                }
            })
            task.resume()
            
            
        })
        
        if(doIt == true){
            
        }
    }
    
    
    func upload_comment(){
        
        println("Data is: \(self.commentView.text)")
        
        var hashids = ""
        
        for i in 0...(self.fakeHashtags.count - 1){
            if(self.hashtagSelectedIndex[self.hashtagIdIndex[self.fakeHashtags[i]]!]! == true){
                let hashNum = self.hashtagIdIndex[self.fakeHashtags[i]]!
                hashids += "\(hashNum)"
                println("THE HASH ID:\(hashids)")
                hashids += " "
            }
        }
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_submit_this_comment")
        //let url = NSURL(string: "http://www.groopie.co/mobile_get2_top_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["cBody":self.commentView.text, "fb_id":authorID, "latLon":sentLocation, "imgLink":imageLink, "hashids":hashids] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    
                    
                    
                    
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                else {
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
        
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.everythingScrollHolderBottomConstraint.constant = keyboardFrame.size.height + 20
            self.hashtagHolderHeightConstraint.constant = 70
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.everythingScrollHolderBottomConstraint.constant = 0
            self.hashtagHolderHeightConstraint.constant = 160
            
        })
    }
    
    
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        // print(textView.text); //the textView parameter is the textView where text was changed
        let height2 = commentView.frame.height + oimageView.frame.height + 200.0
        // scrollView.contentSize = CGSize(width:scrollView.frame.width, height:height2)
        
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                println("Error:" + error.localizedDescription)
                return
                
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                //self.displayLocationInfo(pm)
                
                self.sentLocation = String("\(pm.location.coordinate.latitude), \(pm.location.coordinate.longitude)")
                //print(pm.location.coordinate.latitude)
                //print(pm.location.coordinate.longitude)
                
                println(self.sentLocation)
                self.locationManager.stopUpdatingLocation()
                
            }else {
                println("Error with data")
                
            }
            
            
        })
    }
    
    
    
    
    
}