//
//  CommentLikersViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 4/1/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//
import UIKit



class CommentLikersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    
    // @IBOutlet var commentLabel: UILabel!
    //@IBOutlet var authorLabel: UILabel!
    //@IBOutlet var authorPicture: UIImageView!
    //@IBOutlet var commentView: UITextView!
    //@IBOutlet var replyHolderView: UIView!
    @IBOutlet var tableView: UITableView! //holds replies and likes
  //  @IBOutlet var tabBar: UITabBar! //controls tableview
    //@IBOutlet var scrollView: UIScrollView!
    
//    @IBOutlet var replyCommentView: UITextField!
//    
//    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
//    
//    @IBOutlet var replyButton: UIButton!
    
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
        
        //self.tableView.registerClass(custom_cell.self, forCellReuseIdentifier: "custom_cell")
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.estimatedRowHeight = 168.0
        tableView.rowHeight = UITableViewAutomaticDimension
        

        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        self.tableView.separatorColor = color
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        self.tableView.separatorInset.left = 0
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        
 
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
        get_likers()
        
        
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
        
        //println("S:LKDFJL:SKDFLSDK")
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as NSNumber).unsignedIntValue << 16
        
        
        // let animationCurve = UIViewAnimationOptions.fromRaw(UInt(rawAnimationCurve))!
        
        let animationCurve = UIViewAnimationOptions(UInt(rawAnimationCurve))
        
      //  bottomLayoutConstraint.constant = 0 - CGRectGetMinY(convertedKeyboardEndFrame)/2 - replyHolderView.frame.height
        
     //   UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
       //     self.view.layoutIfNeeded()
        //    }, completion: nil)
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

        var cell = tableView.dequeueReusableCellWithIdentifier("user_cell") as user_cell
        
        
        var fbid = theJSON["results"]![indexPath.row]["userID"] as String!
        
        
        let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?width=50&height=50")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        
        cell.userImage?.image = UIImage(data: data!)
        cell.nameLabel.text = theJSON["results"]![indexPath.row]["userName"] as String!
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height
        let followTest = theJSON["results"]![indexPath.row]["userFollow"] as String!
        //test if general user is following the presented user
        //cell.followButton.titleLabel?.text = "test"
        
        if(followTest == "yes"){//the user is follow, we give option to change
            //cell.followButton.setTitle("Unfollow", forState: UIControlState.Normal)
            cell.followButton.setImage(UIImage(named: "Unfollow.png"), forState: UIControlState.Normal)
        }
        else{
            // cell.followButton.setTitle("Follow", forState: UIControlState.Normal)
            cell.followButton.setImage(UIImage(named: "Follow.png"), forState: UIControlState.Normal)
        }
        
        // cell.followButton.addTarget(self, action: "DidPressFollow:", forControlEvents: .TouchUpInside)
        //cell.followButton.tag = indexPath.row
        cell.userFBID = fbid
        
        return cell
        
        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as ProfileViewController
        
        
        //  var authorLabel = sender.view? as UILabel
        
        //   let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        
        let gotCell = tableView.cellForRowAtIndexPath(indexPath) as user_cell
        
        profView.userFBID = gotCell.userFBID
        profView.userName = gotCell.nameLabel.text!
        
        
        
        self.presentViewController(profView, animated: true, completion: nil)
        

        
        
    }
 
    func get_likers(){
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_comment_likers")
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
                    self.focusTableOn = "likers"
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
    
//    @IBAction func did_hit_reply(){
//        //func did_hit_reply(){
//        
//        println("Data is: \(self.replyCommentView.text)")
//        
//        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_reply_to_comment")
//        //let url = NSURL(string: "http://www.groopie.co/mobile_get2_top_comments")
//        //START AJAX
//        var request = NSMutableURLRequest(URL: url!)
//        var session = NSURLSession.sharedSession()
//        request.HTTPMethod = "POST"
//        
//        var params = ["rBody":self.replyCommentView.text, "fb_id":savedFBID, "latLon":sentLocation, "imgLink":imageLink, "cID":commentID] as Dictionary<String, String>
//        
//        
//        var err: NSError?
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            println("Response: \(response)")
//            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("Body: \(strData)")
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
//            
//            
//            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
//            if(err != nil) {
//                println(err!.localizedDescription)
//                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                println("Error could not parse JSON: '\(jsonStr)'")
//            }
//            else {
//                // The JSONObjectWithData constructor didn't return an error. But, we should still
//                // check and make sure that json has a value using optional binding.
//                if let parseJSON = json {
//                    
//                    
//                    
//                    
//                    
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                    
//                }
//                else {
//                    
//                }
//            }
//        })
//        task.resume()
//        
//        
//        // println("SLKDJFLSKDJFSDFLKJS")
//        //     self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    
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
