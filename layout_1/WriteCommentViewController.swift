
//
//  WriteCommentViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/10/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit
import MobileCoreServices

class SweetView: UIImageView {
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 67, height: 67);
    }
}

class WriteCommentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    
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
    
    var imagePicker: UIImagePickerController!
    
    var hasImage = false
    
    var savedImage: UIImage!
    
    var imageLink = "none"
  //  var captureDeviceBack : AVCaptureDevice?
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  let tracker = GAI.sharedInstance().defaultTracker
      //  tracker.set(kGAIScreenName, value: "/index")
      //  tracker.send(GAIDictionaryBuilder.createScreenView().build())
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("SolveGame", action: "GameSolved", label: "Solve", value: nil).build())
        
      //  self.commentView.becomeFirstResponder()

        
     //  scrollView.contentSize = CGSizeMake(400, 2300)
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id")
        self.authorID = fbid!
        

  
        
        
        commentView.text = "Enter a comment...."
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height2 = commentView.frame.height + oimageView.frame.height + 40
        scrollView.contentSize = CGSize(width:scrollView.frame.width, height:height2)
        
        println("THIS IS THE SENT LOCATION:\(sentLocation)")
        
        
        let imageTap = UITapGestureRecognizer(target: self, action:Selector("clickImage:"))
        // 4
        imageTap.delegate = self
        oimageView.userInteractionEnabled = true
        oimageView.addGestureRecognizer(imageTap)
        scrollView.bringSubviewToFront(oimageView)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
       // let imageView:UIImageView!
        //let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        
        savedImage = imageWithImage(image!, scaledToSize: CGSizeMake(600, 600))
//    let imageView = UIImageView(image: savedImage!)
//       //  imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//    imageView.sizeThatFits(CGSizeMake(100, 200))
//        
//        imageView.intrinsicContentSize()
//      //  self.view.addSubview(imageView)
//     //   self.scrollView.addSubview(imageView)
//        
        
        oimageView.image = savedImage
        hasImage = true
        
//        let leftConstraint = NSLayoutConstraint(item: imageView,
//            attribute: .Right,
//            relatedBy: .Equal,
//            toItem: self.view,
//            attribute: .Right,
//            multiplier: 1.0,
//            constant: 0.0);
//        
//        self.view.addConstraint(leftConstraint);
//        
//       // self.view.layOutIfNeeded()
//        self.view.layoutIfNeeded()
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
    
    @IBAction func showCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            println("Button capture")
            
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    @IBAction func did_press_cancel(){
        
        self.commentView.resignFirstResponder()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func did_submit_comment(){
         self.commentView.resignFirstResponder()
        self.showLoadingScreen()
        if(hasImage == true){
            
            upload_picture()
        }
        else{
            upload_comment()
        }
        
    }
    
    
    
    func showLoadingScreen(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let squareSize = screenSize.width * 0.5
        let xPos = screenSize.width/2 - squareSize/2
        let yPos = screenSize.height/2 - squareSize/2
        
        let holdView = UIView(frame: CGRect(x: xPos, y: yPos, width: squareSize, height: squareSize*1.1))
        holdView.backgroundColor = UIColor.whiteColor()
        holdView.tag = 999
        
        holdView.layer.borderWidth=1.0
        holdView.layer.masksToBounds = false
        holdView.layer.borderColor = UIColor.blackColor().CGColor
        //profilePic.layer.cornerRadius = 13
        holdView.layer.cornerRadius = holdView.frame.size.height/10
        holdView.clipsToBounds = true
        
        view.addSubview(holdView)
        
        
        
        
        
        
        var label = UILabel(frame: CGRectMake(0, 0, holdView.frame.width, holdView.frame.height*0.2))
        label.textAlignment = NSTextAlignment.Center
        label.text = "Loading Comments..."
        holdView.addSubview(label)
        
        
        
        
        // Returns an animated UIImage
        var url = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
        var imageData = NSData(contentsOfURL: url!)
        
        
        let image = UIImage.animatedImageWithData(imageData!)//UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let smallerSquareSize = squareSize*0.6
        let gPos = (holdView.frame.width - smallerSquareSize)/2
        
        
        imageView.frame = CGRect(x: gPos, y: gPos*1.8, width: smallerSquareSize, height: smallerSquareSize)
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
        var imageData: NSData = UIImageJPEGRepresentation(image, 0.7)
        
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
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            //commentView.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
       // print(textView.text); //the textView parameter is the textView where text was changed
        let height2 = commentView.frame.height + oimageView.frame.height + 40
        scrollView.contentSize = CGSize(width:scrollView.frame.width, height:height2)
        
    }
    
    
}