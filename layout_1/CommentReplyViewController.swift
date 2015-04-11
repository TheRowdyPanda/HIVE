//
//  CommentReplyViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 4/2/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//
import UIKit

class CommentReplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITextFieldDelegate{
    
    
    // @IBOutlet var commentLabel: UILabel!
    //@IBOutlet var authorLabel: UILabel!
    //@IBOutlet var authorPicture: UIImageView!
    //@IBOutlet var commentView: UITextView!
    @IBOutlet var replyHolderView: UIView!
    @IBOutlet var tableView: UITableView! //holds replies and likes
    //  @IBOutlet var tabBar: UITabBar! //controls tableview
    //@IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var replyCommentView: UITextField!
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet var replyButton: UIButton!
    
    // @IBOutlet weak var comImageConstraint: NSLayoutConstraint!
    var testString = "1"
    var comment = "empty"
    var author = "empty"
    var imgLink = "empty"
    var authorFBID = "empty"
    
    var commentID = "empty"
    
    var imageLink = "none"
    
    var savedFBID = "none"
    
    //  var comImage: UIImageView!
    //    @IBOutlet var comImage: UIImageView!
    
    var sentLocation = "none"
    
    
    var hasLoaded = false
    var theJSON: NSDictionary!
    var focusTableOn = "none"
    var numOfCells = 0
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.commentLabel.text = comment
        //self.commentView.text = comment
        // self.commentView.text = "S:DKFJS:KDFJS:KDFJ:SLKJF:LSKDFJ SDF:LKSDJF:KS DFKSDF:LKSDF:LKDF:SDJF:KSLDF:SLDFKJS:LDKFJS:LFDKJS:LDKFS:LDFKJ"
        //self.authorLabel.text = author
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("reload_table"), userInfo: nil, repeats: false)
        let defaults = NSUserDefaults.standardUserDefaults()
        savedFBID = defaults.stringForKey("saved_fb_id")!
        
        replyCommentView.delegate = self
        //self.tableView.registerClass(custom_cell.self, forCellReuseIdentifier: "custom_cell")
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        self.tableView.separatorColor = color
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        self.tableView.separatorInset.left = 0
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.estimatedRowHeight = 168.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //println("THIS IS THE SENT LOCATION:\(sentLocation)")
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        super.viewWillAppear(animated)
        //        let firstItem = tabBar.items![0] as UITabBarItem
        //        tabBar.selectedItem = firstItem
        //get_comment_replies()
        get_comments()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    
    
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as NSNumber).unsignedIntValue << 16
        
        
        
        let animationCurve = UIViewAnimationOptions(UInt(rawAnimationCurve))
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()

        bottomLayoutConstraint.constant = keyboardFrame.size.height + 1
           UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
             self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    //pragma mark - table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(hasLoaded == false){
            return numOfCells
        }
        else{
            return numOfCells
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        println("DID SHOW CELL")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("reply_cell") as reply_cell
        
        
        var fbid = theJSON["results"]![indexPath.row]["user_id"] as String!
        
        
        let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?width=50&height=50")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        
        cell.userImage?.image = UIImage(data: data!)
        cell.nameLabel.text = theJSON["results"]![indexPath.row]["author"] as String!
        
        cell.replyLabel.text = theJSON["results"]![indexPath.row]["comments"] as String!
        //cell.replyLabel.text = "SLKFJSLKJF"
        cell.userFBID = fbid
        
        return cell

        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as ProfileViewController
        
        
        //  var authorLabel = sender.view? as UILabel
        
        //   let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        
        let gotCell = tableView.cellForRowAtIndexPath(indexPath) as reply_cell
        
        profView.userFBID = gotCell.userFBID
        profView.userName = gotCell.nameLabel.text!
        
        
        
        self.presentViewController(profView, animated: true, completion: nil)
        
        
    }
    
    func get_comments(){
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_comment_replies")
        //let url = NSURL(string: "http://www.groopie.co/mobile_get2_top_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fb_id":savedFBID, "latLon":sentLocation, "cID":commentID] as Dictionary<String, String>
        
        
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
                    
                    
                    
                    self.theJSON = parseJSON
                    self.hasLoaded = true
                    self.focusTableOn = "replies"
                    self.numOfCells = parseJSON["results"]!.count
                    
                    self.reload_table()
                    //  self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                else {
                    
                }
            }
        })
        task.resume()
    }
    
    @IBAction func did_hit_reply(){
        //func did_hit_reply(){
        
        println("Data is: \(self.replyCommentView.text)")
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_reply_to_comment")
        //let url = NSURL(string: "http://www.groopie.co/mobile_get2_top_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["rBody":self.replyCommentView.text, "fb_id":savedFBID, "latLon":sentLocation, "imgLink":imageLink, "cID":commentID] as Dictionary<String, String>
        
        
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
                    
                    
                    self.finishedReply()
                    
                    
                  //  self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                else {
                    
                }
            }
        })
        task.resume()
        
        
        // println("SLKDJFLSKDJFSDFLKJS")
        //     self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func finishedReply(){
        dispatch_async(dispatch_get_main_queue(),{

        self.replyCommentView?.resignFirstResponder()

       // UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        self.get_comments()
            
            
            let animationDuration = 0.2
            self.replyCommentView?.text = ""
            
            self.bottomLayoutConstraint.constant = 0.0
            UIView.animateWithDuration(animationDuration, delay: 0.0, options:nil, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            
            // self.removeLoadingScreen()
        })
    }
    
    func reload_table(){
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                // self.removeLoadingScreen()
            })
            
        }
        
    }
    
    
    @IBAction func did_click_flag(){
    
        let alertController = UIAlertController(title: "Flagged!", message:
            "This post has been flagged for inappropriate content.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay, cool.", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    //    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
    //        if(item.tag == 1){
    //            //  println("PPSDJFOSDJF")
    //            get_comment_replies()
    //        }
    //        if(item.tag == 2){
    //            get_comment_likers()
    //        }
    //    }
    //    
    //    
}
