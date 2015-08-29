//
//  DirectMessagingViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 8/22/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//
import UIKit



class DirectMessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var inputTextField: UITextField!
    
    
    var userImageCache = [String: UIImage]()
    var refreshControl:UIRefreshControl!
    var hasLoaded = false
    //var theJSON: NSDictionary!
    var theJSON: NSMutableDictionary!
    var savedFBID = "none"
    var userFBID = "none"
    var userName = "none"
    var mostRecentMessageId = ""
    var numOfCells = 0
    var oldScrollPost:CGFloat = 0.0
    
  var timer:NSTimer? = nil;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.theJSON = NSMutableDictionary()
        self.inputTextField.delegate = self
        self.nameLabel.text = self.userName
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        savedFBID =
            defaults.stringForKey("saved_fb_id")!
        

        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        backButton.addTarget(self, action: Selector("backWasPressed"), forControlEvents: UIControlEvents.TouchUpInside)

        let tableTap = UITapGestureRecognizer(target: self, action:Selector("tableWasTapped:"))
        // 4
        tableTap.delegate = self
        self.view.addGestureRecognizer(tableTap)
        //tableView.addGestureRecognizer(tableTap)
        self.getMessages();
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.separatorInset.left = 20
        self.tableView.separatorInset.right = 20
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func backWasPressed(){
       // self.modalTransitionStyle = .FlipHorizontal
        self.timer?.invalidate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var ff = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(ff!, animations: { () -> Void in
            self.bottomTableConstraint.constant = keyboardFrame.size.height + 0
            //self.hashtagHolderHeightConstraint.constant = 70
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.bottomTableConstraint.constant = 0
          //  self.hashtagHolderHeightConstraint.constant = 160
            
        })
    }
    
    func tableWasTapped(sender: UIGestureRecognizer){
        println("CHECK IT OUT1")
        if(self.inputTextField.isFirstResponder() == true){
            self.inputTextField.resignFirstResponder()
        }
    }
    
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
        //let testImage = theJSON["results"]![indexPath.row]["image"] as! String!
        let testType = theJSON["results"]![indexPath.row]["type"] as! String!
        
        if(testType == "1"){
        var cell = tableView.dequeueReusableCellWithIdentifier("me_dm_cell_id") as! me_dm_cell
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.separatorInset.left = 20
        cell.separatorInset.right = 20
        cell.layoutMargins = UIEdgeInsetsZero
        cell.tag = 100
        
        
        
        //set the cell contents with the ajax data
        //cell.nameLabel?.text = theJSON["results"]![indexPath.row]["authorName"] as! String!
            cell.messageLabel?.text = theJSON["results"]![indexPath.row]["message"] as! String!
      
        return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("user_dm_cell_id") as! user_dm_cell
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.separatorInset.left = 20
            cell.separatorInset.right = 20
            cell.layoutMargins = UIEdgeInsetsZero
            cell.tag = 100
            
            cell.messageLabel?.text = theJSON["results"]![indexPath.row]["message"] as! String!
            
            //set the cell contents with the ajax data
            //cell.nameLabel?.text = theJSON["results"]![indexPath.row]["authorName"] as! String!
           // let userFBID = theJSON["results"]![indexPath.row]["authorFBID"] as! String!
            
            let testUserImg = "http://graph.facebook.com/\(userFBID)/picture?width=100&height=100"
            //        let imgURL: NSURL = NSURL(string: testUserImg)!
            //        let imgData = NSData(contentsOfURL: imgURL)
            //        let upImage = UIImage(data: imgData!)
            //        cell.userImage?.image = upImage
            
            var upimage = self.userImageCache[testUserImg]
            if( upimage == nil ) {
                // If the image does not exist, we need to download it
                
                var imgURL: NSURL = NSURL(string: testUserImg)!
                
                // Download an NSData representation of the image at the URL
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        upimage = UIImage(data: data)
                        
                        // Store the image in to our cache
                        self.userImageCache[testUserImg] = upimage
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? user_dm_cell {
                                cellToUpdate.userImage?.image = upimage
                            }
                        })
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? user_dm_cell {
                        cellToUpdate.userImage?.image = upimage
                    }
                })
            }
            
            
            return cell

        }

    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    
    
    func parseHTMLString(daString:NSString) -> [NSString]{
        
        
        println("DA STRING:\(daString)")
        let detector = NSDataDetector(types: NSTextCheckingType.Link.rawValue, error: nil)
        
        let fakejf = String(daString)
        //let length = fakejf.utf16Count
        let length = count(fakejf.utf16)
        let daString2 = daString as! String
        // let links = detector?.matchesInString(daString, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, length)).map {$0 as NSTextCheckingResult}
        
        let links = detector?.matchesInString(daString2, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, length)).map {$0 as! NSTextCheckingResult}
        
        //        var d = daString as StringE
        //        if (d.containsString("Http://") == true){
        //            println(daString)
        //            println("YEAH BUDDY")
        //        }
        
        var retString = NSString(string: "none")
        //
        
        return links!.filter { link in
            return link.URL != nil
            }.map { link -> NSString in
                //let urString = String(contentsOfURL: link.URL!)
                let urString = link.URL!.absoluteString
                println("DA STRING:\(urString)")
                retString = urString!
                return urString!
        }
        
        // var newString = retString
        //
        return [retString]
        //return "OH YEAH"
    }
    
    
    func getMessages(){
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_user_get_messages")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        var params = ["gfbid":fbid, "rfbid":userFBID] as Dictionary<String, String>
        
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
                    
                    self.theJSON = parseJSON as! NSMutableDictionary
                    self.numOfCells = parseJSON["results"]!.count
                    
                    println("TEH CELL COUNT\(self.numOfCells)")
                    if(self.numOfCells > 0){
                        self.mostRecentMessageId = parseJSON["results"]![self.numOfCells - 1]!["id"] as! String
                        
                    }
                    else{
                        self.mostRecentMessageId = "0"
                    }
                self.reload_table()
                    
                    //self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateComments"), userInfo: nil, repeats: true)
                    dispatch_async(dispatch_get_main_queue(), {
                     self.timer = NSTimer.scheduledTimerWithTimeInterval(20, target:self, selector: Selector("updateComments"), userInfo: nil, repeats: true)
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
    
    func updateComments(){
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_user_get_new_messages")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        var params = ["gfbid":fbid, "rfbid":userFBID, "mostRecentCommentId":mostRecentMessageId] as Dictionary<String, String>
        
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
                    
                    //                    self.theJSON = parseJSON as! NSMutableDictionary
                    //                    self.numOfCells = parseJSON["results"]!.count
                    
                    if(parseJSON["results"]!.count > 0){
                        for i in 0...(parseJSON["results"]!.count - 1){
                            let sT = parseJSON["results"]![i]["message"] as! String
                            let sI = parseJSON["results"]![i]["id"] as! String
                           // self.insertCommentInTable(sT, id: sI)
                            self.insertOtherUserCommentInTable(sT, id: sI)
                        }
                        
                        let daNum = parseJSON["results"]!.count
                        self.mostRecentMessageId = parseJSON["results"]![daNum - 1]!["id"] as! String
                        
                        self.reload_table()
                    }
                    // insertOtherUserCommentInTable
                    
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    
                }
            }
        })
        task.resume()
        
    }
    
    func reload_table(){
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                // self.removeLoadingScreen()
                self.tableView.layoutIfNeeded()
                
                var yOffset: CGFloat = 0.0;
                
                if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
                    yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
                }
                
                self.tableView.setContentOffset(CGPoint(x: 0.0, y: yOffset), animated: false)
                
            })
            
            
        }
        
    }
    
    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n"){
//            textView.resignFirstResponder()
//            self.submitComment()
//            return false
//        }
//
//        return true
//    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n"){
            //self.inputTextField.resignFirstResponder()
            self.inputTextField.textColor = UIColor.grayColor()
            self.submitComment()
            return false
        }
        
        return true
    }

    func submitComment(){
    let textValue = self.inputTextField.text
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_user_submit_dm")

        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        var params = ["message":textValue, "gfbid":fbid, "rfbid":userFBID] as Dictionary<String, String>
        
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
                        let theID = parseJSON["results"] as! String
                        println("THE ID:\(theID)")
                        
                   
                       // self.insertCommentInTable(self.inputTextField.text)
                        self.insertCommentInTable(self.inputTextField.text, id: theID)
                    self.inputTextField.text = ""
                    self.inputTextField.resignFirstResponder()
                        self.inputTextField.textColor = UIColor.blackColor()
                     })
                }
                else {
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
    }
    
    func insertOtherUserCommentInTable(text:String, id:String){
        
        var oldDict = NSMutableArray(array: self.theJSON["results"] as! [AnyObject])
        
        var newComment = ["message":text, "id":id, "type":"2"] as Dictionary<String, String>
        
        oldDict.addObject(newComment)
        var newDict = ["results": oldDict]
        
        self.theJSON = NSMutableDictionary(dictionary: newDict)
        self.numOfCells = self.numOfCells + 1
    }
   
    func insertCommentInTable(text: String, id: String){
        
        self.mostRecentMessageId = id

        var oldDict = NSMutableArray(array: self.theJSON["results"] as! [AnyObject])

        var newComment = ["message":text, "id":id, "type":"1"] as Dictionary<String, String>

        oldDict.addObject(newComment)
        var newDict = ["results": oldDict]

        self.theJSON = NSMutableDictionary(dictionary: newDict)
        self.numOfCells = self.numOfCells + 1
        self.reload_table()
        println(theJSON)
     
    }
    
    func showUserProfile(sender: UIGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as! ProfileViewController
        
        
        //var authorLabel = sender.view? as UILabel
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
            
            //profView.comment = gotCell.comment_label.text!
            profView.userFBID = gotCell.user_id
            
            profView.userName = gotCell.author_label.text!
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
            
            //profView.comment = gotCell.comment_label.text!
            profView.userFBID = gotCell.user_id
            
            profView.userName = gotCell.author_label.text!
        }
        
        
        self.presentViewController(profView, animated: true, completion: nil)
        
        
    }
    
    func loadMessages(){
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_user_get_messages")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        var params = ["gfbid":fbid, "rfbid":userFBID] as Dictionary<String, String>
        
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
                        self.reload_table()
                       
                        
                    })
                    //self.hashtagScrollHolder.reloadInputViews()
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    
                }
            }
        })
        task.resume()
        //END AJAX
        

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
        
        self.view.addSubview(holdView)
        
        
        
        
        
        
        var label = UILabel(frame: CGRectMake(0, 0, holdView.frame.width, holdView.frame.height*0.2))
        label.textAlignment = NSTextAlignment.Center
        label.text = "Loading Comments..."
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
    
    
    
    
}

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}