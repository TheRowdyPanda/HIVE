//
//  ViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/14/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var customSC: UISegmentedControl!
    
    var hasLoaded = false
    var theJSON: NSDictionary!
    var savedFBID = "none"
    var numOfCells = 0
    
    
    var currentUserLocation = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        
        //get the user facebook id. This is used to identify the user in all ajax requests
        let defaults = NSUserDefaults.standardUserDefaults()
        savedFBID = defaults.stringForKey("saved_fb_id")!
        
        
        
  
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension

        //get the top comments in the "THEJSON" var, then reload the table
        loadTopComments()
        
        showLoadingScreen()
        
        //set up the segmented control action
        customSC.addTarget(self, action: "toggleComments:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
 
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    //pragma mark - table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //make sure the json has loaded before we do anything
        if(hasLoaded == false){
            return numOfCells
        }
        else{
            return numOfCells
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell") as custom_cell
        
        
        //set the cell contents with the ajax data
        cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as String!
        cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as String!
        cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as String!
        cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as String!
        cell.heart_label?.text = theJSON["results"]![indexPath.row]["hearts"] as String!
        
        //find out if the user has liked the comment or not
        var hasLiked = theJSON["results"]![indexPath.row]["has_liked"] as String!
        
        if(hasLiked == "yes"){
            cell.heart_icon?.userInteractionEnabled = true
            cell.heart_icon?.image = UIImage(named: "honey_full.jpg")
            
            let voteDown = UITapGestureRecognizer(target: self, action:Selector("voteCommentDown:"))
            // 4
            voteDown.delegate = self
            cell.heart_icon?.tag = indexPath.row
            cell.heart_icon?.addGestureRecognizer(voteDown)
 
            
        }
        else if(hasLiked == "no"){
            cell.heart_icon?.userInteractionEnabled = true
            cell.heart_icon?.image = UIImage(named: "honey_empty.jpg")
            
            let voteUp = UITapGestureRecognizer(target: self, action:Selector("voteCommentUp:"))
            // 4
            voteUp.delegate = self
            cell.heart_icon?.tag = indexPath.row
            cell.heart_icon?.addGestureRecognizer(voteUp)
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as ThirdViewController
        
        let gotCell = tableView.cellForRowAtIndexPath(indexPath) as custom_cell
        
        comView.comment = gotCell.comment_label.text!
        
        comView.author = gotCell.author_label.text!
        
        
        
       // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(comView, animated: true, completion: nil)
        
    }
    

    
    
    
    //pragma mark - ajax
    func loadTopComments(){
        
        showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get2_top_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID] as Dictionary<String, String>
        
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
                    
                       self.theJSON = json
                      self.hasLoaded = true
                     self.numOfCells = parseJSON["results"]!.count
                    
                     self.reload_table()

                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    
                }
            }
        })
        task.resume()
        //END AJAX
        

        
    }
    
    func loadNewComments(){
        
        
        showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get2_new_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID] as Dictionary<String, String>
        
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
                    
                    self.theJSON = json
                    self.hasLoaded = true
                    self.numOfCells = parseJSON["results"]!.count
                    
                    self.reload_table()
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
        
        
    }

    
    
    
    func reload_table(){
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                    self.removeLoadingScreen()
            })
            
        }
        
    }
    
    
    
    func voteCommentUp(sender: UIGestureRecognizer){
        
        //get the attached sender imageview
        var heartImage = sender.view? as UIImageView
        //get the main view
        
        var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as custom_cell
    
        
        //get the cell comment id. Send this to ajax request
        var cID = cellView.comment_id
        
        
        
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_user_like_comment")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "comment_id":String(cID)] as Dictionary<String, String>
        
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
                    dispatch_async(dispatch_get_main_queue(),{
                    //change the heart image
                    heartImage.image = UIImage(named: "honey_full.jpg")
                    
                    //get heart label content as int
                    var curHVal = cellView.heart_label?.text?.toInt()
                    //get the heart label
                    cellView.heart_label?.text = String(curHVal! + 1)
                    })
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
    }
    
    
    func voteCommentDown(sender: UIGestureRecognizer){
        
        //get the attached sender imageview
        var heartImage = sender.view? as UIImageView
        //get the main view
        
        var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as custom_cell
        
        
        //get the cell comment id. Send this to ajax request
        var cID = cellView.comment_id
        
        
        
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_user_unlike_comment")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "comment_id":String(cID)] as Dictionary<String, String>
        
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
                    dispatch_async(dispatch_get_main_queue(),{
                    //change the heart image
                    heartImage.image = UIImage(named: "honey_empty.jpg")
                    
                    //get heart label content as int
                    var curHVal = cellView.heart_label?.text?.toInt()
                    //get the heart label
                    cellView.heart_label?.text = String(curHVal! - 1)
                    })
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // pragma mark - layout
    
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
    
    @IBAction func showWriteViewController(){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let writeView = mainStoryboard.instantiateViewControllerWithIdentifier("write_comment_scene_id") as WriteCommentViewController
        
       writeView.sentLocation = currentUserLocation
        
        
       // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(writeView, animated: true, completion: nil)
        
    }
    
    
    func toggleComments(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadTopComments()
        case 1:
            loadNewComments()
        default:
            loadTopComments()
        }
    }
    
    
    
    
    
    
    //pragma mark - core location
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                println("Error:" + error.localizedDescription)
                return
                
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                //self.displayLocationInfo(pm)
                
                self.currentUserLocation = String("\(pm.location.coordinate.latitude), \(pm.location.coordinate.longitude)")
                //print(pm.location.coordinate.latitude)
                //print(pm.location.coordinate.longitude)
                
                println(self.currentUserLocation)
                
            }else {
                println("Error with data")
                
            }
            
            
        })
    }
    
    
    
    
}