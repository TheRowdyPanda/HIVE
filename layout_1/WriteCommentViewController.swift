
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

class SweetView: UIImageView {
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 67, height: 67);
    }
}

class WriteCommentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var buttonHolder: UIView!
    var testString = "1"
    var comment = "empty"
    var authorID = "empty"
    
    var sentLocation = "none"
    
    @IBOutlet var commentField: UITextField!
    @IBOutlet var commentView: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    
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
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.locationManager.delegate = self
        
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.startUpdatingLocation()
        self.locationManager.distanceFilter = 3
        
        
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
        
        buttonHolder.layer.borderWidth=2.0
                buttonHolder.layer.masksToBounds = false
                buttonHolder.layer.borderColor = color.CGColor//UIColor.blackColor().CGColor
        
                //profilePic.layer.cornerRadius = 13
                buttonHolder.clipsToBounds = true
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Write Comment Scene", action: "Start Comment", label: "Did Begin Editing", value: nil).build() as [NSObject : AnyObject])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height2 = commentView.frame.height + oimageView.frame.height + buttonHolder.frame.height
        scrollView.contentSize = CGSize(width:scrollView.frame.width, height:height2)
        
        println("THIS IS THE SENT LOCATION:\(sentLocation)")
        
        

//        oimageView.userInteractionEnabled = true
//        oimageView.addGestureRecognizer(imageTap)
        scrollView.bringSubviewToFront(oimageView)
        
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
    @IBAction func cameraButton(){
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
    
    
    func clickRoll(sender: UIGestureRecognizer){
        
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
    @IBAction func rollButton(){
        
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
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_submit_this_comment")
        //let url = NSURL(string: "http://www.groopie.co/mobile_get2_top_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["cBody":self.commentView.text, "fb_id":authorID, "latLon":sentLocation, "imgLink":imageLink] as Dictionary<String, String>
        
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

    
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            //commentView.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
       // print(textView.text); //the textView parameter is the textView where text was changed
        let height2 = commentView.frame.height + oimageView.frame.height + 200.0
        scrollView.contentSize = CGSize(width:scrollView.frame.width, height:height2)
        
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