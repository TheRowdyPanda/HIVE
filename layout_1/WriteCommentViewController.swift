
//
//  WriteCommentViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/10/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class WriteCommentViewController: UIViewController {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    var testString = "1"
    var comment = "empty"
    var authorID = "empty"
    
    var sentLocation = "none"
    
    @IBOutlet var commentField: UITextField!
    @IBOutlet var commentView: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    
    
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.commentView.becomeFirstResponder()

        
       scrollView.contentSize = CGSizeMake(400, 2300)
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id")
        self.authorID = fbid!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width:10, height:10)
        println("THIS IS THE SENT LOCATION:\(sentLocation)")
    }
    
    
    @IBAction func did_press_cancel(){
        
        self.commentView.resignFirstResponder()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func did_submit_comment(){
        
        println("Data is: \(self.commentView.text)")
        
         let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_submit_this_comment")
        //let url = NSURL(string: "http://www.groopie.co/mobile_get2_top_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["cBody":self.commentView.text, "fb_id":authorID, "latLon":sentLocation] as Dictionary<String, String>
        
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
                    
                 //   self.theJSON = json
                  //  self.hasLoaded = true
                   // self.numOfCells = parseJSON["results"]!.count
                    
                   // self.reload_table()
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    //self.theJSON = parseJSON
                    //var success = parseJSON["results"]![0]["hearts"] as? String
                    //println("Succes: \(success)")
                    //self.hearts[0] = parseJSON["results"]![0]["hearts"]
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    //let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    //println("Error could not parse JSON: \(jsonStr)")
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
    
    
}