//
//  ProfileViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/7/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit


//http://graph.facebook.com/xUID/picture?width=720&height=720
class ProfileViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var profilePic: UIImageView!
    
    //@IBOutlet var loadingScreen: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var exitButton: UIButton!
    
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var hashtagHolderTopLayoutConstraint: NSLayoutConstraint!
    
    var isBounce:Bool! = false
    var oldScrollPost:CGFloat = 0.0
    var fakeHashtags = ["MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj","MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj","MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj"]
    
//    @IBOutlet var navBar:UINavigationBar!
//    @IBOutlet var navTitle:UINavigationItem!
    
    @IBOutlet var followButton:UIButton!
    @IBOutlet var blockButton:UIButton!
    
    @IBOutlet var hashtagHolder:UIView!
    
    @IBOutlet var mutualFriendsLabel:UILabel!
    
    @IBOutlet var backgroundProfileImage:UIImageView!
    var userFBID = "none"
    var userName = "none"
    //@IBOutlet var postLabelHolder: UIView!
    
    //@IBOutlet var numPostLabel:UILabel!
    
    
    //    @IBOutlet var locLable:UILabel!
    //    @IBOutlet var timeLabel:UILabel!
    //    @IBOutlet var followersName:UILabel!
    //    @IBOutlet var followersLabel:UILabel!
    //    @IBOutlet var followingName:UILabel!
    //    @IBOutlet var followingLabel:UILabel!
    
    var imageCache = [String : UIImage]()
    var userImageCache = [String: UIImage]()
    var postImageCache = [String: UIImage]()
    
    var voterCache = [Int : String]()
    var voterValueCache = [Int : String]()
    
    var currentUserLocation = "none"
    var postSize = 10.0
    var postMargin = 0.0
    let numCellsAtATime = 20
    
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    let leftHandItems: [String] = ["","Last Check In", "Posts", "Followers", "Following"]
    
    var rightHandItems: [String] = ["","@This Place", "250", "92", "99"]
    
    var theJSON: NSDictionary!
    var theUserJSON: NSDictionary!
    var hasLoaded = false
    var numOfCells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //titleItem.title = "TESTING"
        println("THE WIDTH IS:\(self.view.frame.width)")
        
        var url = NSBundle.mainBundle().URLForResource("loader2", withExtension: "gif")
        var imageData = NSData(contentsOfURL: url!)
        
        self.postSize = Double(self.view.frame.width/2.0) + 0.0
        
        
        self.followButton.backgroundColor = UIColor(red: (141.0/255.0), green: (198.0/255.0), blue: (63.0/255.0), alpha: 1.0)
        self.followButton.layer.cornerRadius = 5
        self.followButton.clipsToBounds = true
        
        self.followButton.addTarget(self, action: "followUser", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.blockButton.backgroundColor = UIColor(red: (242.0/255.0), green: (108.0/255.0), blue: (79.0/255.0), alpha: 1.0)
        self.blockButton.layer.cornerRadius = 5
        self.blockButton.clipsToBounds = true
        self.blockButton.addTarget(self, action: "blockUser", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.width/2.0
        self.profilePic.clipsToBounds = true
        self.profilePic.layer.borderColor = UIColor(red: 0.0, green: (199.0/255.0), blue: (169.0/255.0), alpha: 1.0).CGColor
        self.profilePic.layer.borderWidth = 2.0
        
        var myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
        
        currentUserLocation = myCustomViewController.currentUserLocation
        
        
      //  navTitle.title = "My Profile"
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        
        self.exitButton.addTarget(self, action: "dismissSelf", forControlEvents: UIControlEvents.TouchUpInside)
        
        getUserPicture()
        loadUserComments()
        showLoadingScreen()
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.getUserInfo()
        // removeLoadingScreen()
    }
    
    override func viewDidLayoutSubviews() {
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        
    }
    
    
    func dismissSelf(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCells
    }
    
    //3
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as! ThirdViewController
        //
        
        println("DID RECIEVE CLICK")
        let indCell = collectionView.cellForItemAtIndexPath(indexPath) as! profile_post_cellCollectionViewCell
        
        comView.commentID = indCell.comment_id
        //        let indCell = tableView.cellForRowAtIndexPath(indexPath)
        //
        //        if(indCell?.tag == 100){
        //            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell_no_images
        //
        //            comView.sentLocation = currentUserLocation
        //            comView.commentID = gotCell.comment_id
        //        }
        //        if(indCell?.tag == 200){
        //            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell
        //
        //            comView.sentLocation = currentUserLocation
        //            comView.commentID = gotCell.comment_id
        //        }
        //
        
        
        self.presentViewController(comView, animated: true, completion: nil)
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profile_post_cell_id", forIndexPath: indexPath) as! profile_post_cellCollectionViewCell
        
        
        
        cell.postTextLabel?.text = theJSON["results"]![indexPath.row]["comments"] as! String!
        
        
        
        cell.dateLabel?.text = theJSON["results"]![indexPath.row]["date"] as! String!
        cell.heartLabel?.text = voterValueCache[indexPath.row] as String!
        cell.timeLabel?.text = theJSON["results"]![indexPath.row]["time"] as! String!
        cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as! String!
        
        for j in 0...(self.theJSON["results"]![indexPath.row]["hashtags"]!.count - 1){
            let newHashtagText = self.theJSON["results"]![indexPath.row]["hashtags"]![j]["body"] as! String
            let newHashtagId = self.theJSON["results"]![indexPath.row]["hashtags"]![j]["id"] as! NSString
            let daID2 = newHashtagId.integerValue
            cell.hashtagIdIndex[newHashtagText] = daID2
        }
        
        cell.hashtags = self.theJSON["results"]![indexPath.row]["hashtagTitles"] as! [(NSString)]
        for sv in cell.hashtagHolder.subviews{
            sv.removeFromSuperview()
        }
        cell.hashtagButtons.removeAll(keepCapacity: false)
        var mH = 0.0
        var yPos = 0.0
        cell.widthFiller = 0
        for i in 0...(cell.hashtags.count - 1){
            var title = cell.hashtags[i]
            //            var titleLooker = title as String
            //            var daID = theJSON["results"]![indexPath.row]["hashtags"]![titleLooker] as! NSString
            //            let daID2 = daID.integerValue
            //            cell.hashtagIdIndex[titleLooker] = daID2
            let font = UIFont(name: "Lato-Regular", size: 12);
            //let width = Int(title.length)*12
            let width = Int(title.sizeWithAttributes([NSFontAttributeName: font!]).width) + 12
            let height = Int(title.sizeWithAttributes([NSFontAttributeName: font!]).height) + 2
            
            if(height > Int(mH)){
                mH = Double(height)
            }
            
            var xpos = 0.0
            var widthSpacing = 8.0
            if(cell.hashtagButtons.count > 0){
                let holder = cell.hashtagButtons.last! as UIButton!
                xpos = Double(holder.frame.origin.x) + Double(holder.frame.width) + widthSpacing;
            }
            
            cell.widthFiller += width + Int(widthSpacing)
            
            if(Double(cell.widthFiller) > Double(cell.hashtagHolder.frame.width)){
                cell.widthFiller = width + Int(widthSpacing)
                let addPos = (Double(height) + 3.0)
                yPos += addPos
                xpos = 0.0
            }
            var newButton = UIButton(frame: CGRect(x: Int(xpos), y: Int(yPos), width: width, height: Int(height)))
            newButton.backgroundColor = UIColor(red: (255.0/255.0), green: (210.0/255.0), blue: (11/255.0), alpha: 1.0)
            newButton.layer.masksToBounds = true
            newButton.layer.cornerRadius = 4.0
            
            newButton.setTitle(title as String, forState: UIControlState.Normal)
            
            newButton.titleLabel?.font = font
            //newButton.titleLabel?.textColor = UIColor.blackColor()
            newButton.titleLabel?.textAlignment = NSTextAlignment.Left
            newButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0), forState: UIControlState.Normal)
            cell.hashtagHolder.addSubview(newButton)
            cell.hashtagButtons.append(newButton)
            
        }
        
        let hConst = CGFloat(yPos + mH)
        let heightConstraint = NSLayoutConstraint(item: cell.hashtagHolder, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: hConst)
        cell.hashtagHolder.addConstraint(heightConstraint)
        
        // cell.replyLabel?.text = theJSON["results"]![indexPath.row]["numComments"] as! String!
        // Configure the cell
        
        
        
        
        let imageLink = theJSON["results"]![indexPath.row]["image"] as! String!
        
        if(imageLink != "none"){
            
            var upimage = self.postImageCache[imageLink]
            if( upimage == nil ) {
                //If the image does not exist, we need to download it
                
                var imgURL: NSURL = NSURL(string: imageLink)!
                
                //Download an NSData representation of the image at the URL
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        upimage = UIImage(data: data)
                        
                        //  Store the image in to our cache
                        self.postImageCache[imageLink] = upimage
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as? profile_post_cellCollectionViewCell {
                                cellToUpdate.backgroundImage?.image = upimage
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
                    if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as? profile_post_cellCollectionViewCell {
                        cellToUpdate.backgroundImage?.image = upimage
                    }
                })
            }
        }
        else{
            cell.backgroundImage?.image = nil
        }
        
        
        
        
        
        
        
        
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // let flickrPhoto =  photoForIndexPath(indexPath)
        //            let daSize = CGSize(width: 100.0, height: 100.0)
        //            //2
        //            if var size = daSize {
        //                size.width += 10
        //                size.height += 10
        //                return size
        //            }
        let sizer = (self.postSize)
        return CGSize(width: sizer, height: sizer)
    }
    
    //3
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    func getUserPicture(){
        
        //let defaults = NSUserDefaults.standardUserDefaults()
        var fbid = userFBID//defaults.stringForKey("saved_fb_id") as String!
        
        let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?width=200&height=200")
        // let url = NSURL(string: "http://graph.facebook.com/1382309155407327/picture?width=200&height=200")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        if(data != nil){
            profilePic.image = UIImage(data: data!)
            backgroundProfileImage.image = UIImage(data: data!)
            var effect =  UIBlurEffect(style: UIBlurEffectStyle.Light)
            
            var effectView  = UIVisualEffectView(effect: effect)
            
            effectView.frame  = CGRectMake(0, 0, backgroundProfileImage.frame.width, backgroundProfileImage.frame.height)
            
            backgroundProfileImage.addSubview(effectView)
            
        }
        
        
        //
    }
    
    //    func removeLoadingScreen(){
    //
    //        UIView.animateWithDuration(0.3, animations: {
    //            //            self.myFirstLabel.alpha = 1.0
    //            //            self.myFirstButton.alpha = 1.0
    //            //            self.mySecondButton.alpha = 1.0
    //            self.loadingScreen.alpha = 0.0
    //        })
    //
    //    }
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(true)
    //
    //        println("SLKDJF:LSKDJF:LKDJSF:KLSDFLKJ")
    //
    //    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func did_press_karma(){
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let karmaView = mainStoryboard.instantiateViewControllerWithIdentifier("karma_scene_id") as! KarmaViewController
        
        
        self.presentViewController(karmaView, animated: true, completion: nil)
        
    }
    
    @IBAction func customLogout(){
        println("DID START LOGOUT")
        //FBSDKAccessToken.currentAccessToken()
        FBSession.activeSession().closeAndClearTokenInformation()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        //let fbid = defaults.stringForKey("saved_fb_id") as String!
        defaults.removeObjectForKey("saved_fb_id")
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("fb_login_scene_id") as! UIViewController
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //self.presentViewController(mainView, animated: false, completion: nil)
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    
    
    //User info buttons
    
    func showFollowers(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let friendView = mainStoryboard.instantiateViewControllerWithIdentifier("user_friends_scene_id")as! UserFriendsViewController
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        friendView.ajaxRequestString = "followers"
        friendView.userFBID = fbid
        // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(friendView, animated: true, completion: nil)
    }
    
    func showFollowing(){
        
        println("SLDKFJLS:DKFJLS:DKFSDF")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let friendView = mainStoryboard.instantiateViewControllerWithIdentifier("user_friends_scene_id") as! UserFriendsViewController
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        friendView.ajaxRequestString = "following"
        friendView.userFBID = fbid
        // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(friendView, animated: true, completion: nil)
        
    }
    //AJAX
    
    func getUserInfo(){
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_user_get_hashtags")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = userFBID//defaults.stringForKey("saved_fb_id") as String!
        let gfbid = defaults.stringForKey("saved_fb_id") as String!
        
        var params = ["fb_id":fbid, "gfb_id":gfbid] as Dictionary<String, String>
        
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
                self.removeLoadingScreen()
                
            }
            else {
                
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                
                
                
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    let infoJSON = parseJSON as NSDictionary
                    
                    
                    self.fakeHashtags.removeAll(keepCapacity: false)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if(infoJSON["results"]!.count > 0){
                            for j in 0...(infoJSON["results"]!.count - 1){
                                self.fakeHashtags.append(infoJSON["results"]![j]["body"] as! String)
                            }
                        }
                        else{
                            self.fakeHashtags.append("#NoHashtags")
                        }
                        //                        self.locLable!.text = parseJSON["results"]![0]["lastLoc"] as! String! ?? ""
                        //                        self.timeLabel!.text = parseJSON["results"]![0]["lastTime"] as! String! ?? ""
                        //                        self.followersLabel!.text = parseJSON["results"]![0]["followers"] as! String! ?? ""
                        //                        self.followingLabel!.text = parseJSON["results"]![0]["following"] as! String! ?? ""
                        //                        self.numPostLabel!.text = parseJSON["results"]![0]["comments"] as! String! ?? ""
                        self.removeLoadingScreen()
                        self.showUserHashtags()
                        // self.tableView.reloadData()
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
        var widthFiller = 0
        var yPos = 0.0
        var hashtagButtons = [UIButton?]()
        var mH = 0.0
        for i in 0...(self.fakeHashtags.count - 1){
            var title = self.fakeHashtags[i]
            let f = UIFont(name: "Lato-Regular", size: 14.0)
            let width = Int(title.sizeWithAttributes([NSFontAttributeName: f!]).width) + 6
            let height = Int(title.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(24.0)]).height)
            if(height > Int(mH)){
                mH = Double(height)
            }
            var xpos = 5.0
            var widthSpacing = 6.0
            if(hashtagButtons.count > 0){
                let holder = hashtagButtons.last! as UIButton!
                xpos = Double(holder.frame.origin.x) + Double(holder.frame.width) + widthSpacing;
            }
            
            widthFiller += width + Int(widthSpacing)
            
            if(Int(widthFiller) > Int(self.hashtagHolder.frame.width)){
                widthFiller = width + Int(widthSpacing)
                yPos += Double(height) - 5.0
                xpos = 5.0
            }
            
            var newButton = UIButton(frame: CGRect(x: Int(xpos), y: Int(yPos), width: width, height: height))
            newButton.backgroundColor = UIColor.clearColor();//UIColor(red: (255.0/255.0), green: (165.0/255.0), blue: (0.0/255.0), alpha: 1.0)
            
            newButton.setTitle(title as String, forState: UIControlState.Normal)
            newButton.titleLabel?.font = f
            newButton.setTitleColor(UIColor(red: (67.0/255.0), green: (67.0/255.0), blue: (67.0/255.0), alpha: 1.0), forState: UIControlState.Normal)
            
            self.hashtagHolder.addSubview(newButton)
            hashtagButtons.append(newButton)
        }
        let hConst = CGFloat(yPos + mH)
        let heightConstraint = NSLayoutConstraint(item: self.hashtagHolder, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: hConst)
        self.hashtagHolder.addConstraint(heightConstraint)
        
    }
    
    
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        
        // getMyFriends()
    }
    
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    
    func parseHTMLString(daString:NSString) -> [NSString]{
        
        let daString2 = daString as! String
        
        println("DA STRING:\(daString)")
        let detector = NSDataDetector(types: NSTextCheckingType.Link.rawValue, error: nil)
        
        let fakejf = String(daString)
        //let length = fakejf.utf16Count
        let length = count(fakejf.utf16)
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
    
    
    
    
    func loadUserComments(){
        
        
        // showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_user_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = userFBID//defaults.stringForKey("saved_fb_id") as String!
        let gfbid = defaults.stringForKey("saved_fb_id") as String!
        let offset = String(self.numOfCells)
        let count = String(self.numCellsAtATime)
        
        // var params = ["fbid":savedFBID, "recentLocation":currentUserLocation, "radiusValue":String(radValue)] as Dictionary<String, String>
        
        var params = ["fbid":fbid, "gfbid":gfbid, "offset":offset, "count":count] as Dictionary<String, String>
        
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
                    self.writeVoterCache()
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
    
    func writeVoterCache(){
        
        let finNum = (theJSON["results"]!.count - 1)
        
        if(finNum >= 0){
            
            for index in 0...finNum{
                self.voterCache[index] = theJSON["results"]![index]["has_liked"] as? String
                self.voterValueCache[index] = theJSON["results"]![index]["hearts"] as? String
            }
        }
        
    }
    
    
    func reload_table(){
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
                self.collectionView.reloadData()
                // self.removeLoadingScreen()
            })
            
        }
        
    }
    
    
    func shareComment(sender: UIGestureRecognizer){
        
        
        println("DID PRESS SHARE")
        var sharedButton:AnyObject
        //        if(sender.view? == UIImageView()){
        //
        //          sharedButton = sender.view? as UIImageView
        //
        //        }
        //        else{
        //            sharedButton = sender.view? as UILabel
        //        }
        
        sharedButton = sender.view!
        
        
        
        //        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag, inSection: 0))
        //
        //        if(indCell?.tag == 100){
        //            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell_no_images
        //
        //
        //            let shareCom = gotCell.comment_label.text as String!
        //            let shareAuth = gotCell.author_label.text as String!
        //
        //            let giveMess = "'\(shareCom)'  @\(shareAuth) \n\n @SoLoCoHive (http://apple.co/1yTV9Fj)"
        //
        //
        //
        //
        //            let objectsToShare = [giveMess]
        //
        //            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //             activityVC.popoverPresentationController?.sourceView = self.view
        //            //New Excluded Activities Code
        //            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop,
        //                UIActivityTypeAddToReadingList,
        //                UIActivityTypePostToTencentWeibo,
        //                UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMail,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint]
        //            //
        //
        //            self.presentViewController(activityVC, animated: true, completion: nil)
        //
        //
        //
        //        }
        //        if(indCell?.tag == 200){
        //            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell
        //
        //
        //            let shareCom = gotCell.comment_label.text as String!
        //            let shareAuth = gotCell.author_label.text as String!
        //
        //            let giveMess = "'\(shareCom)'  @\(shareAuth) \n\n @SoLoCoHive (http://apple.co/1yTV9Fj)"
        //            let hiveSite = NSURL(string: "http://apple.co/1yTV9Fj")
        //
        //            let shareImage = gotCell.comImage?.image as UIImage!
        //
        //            let objectsToShare = [giveMess, shareImage]
        //
        //            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //             activityVC.popoverPresentationController?.sourceView = self.view
        //            //New Excluded Activities Code
        //            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop,
        //                UIActivityTypeAddToReadingList,
        //                UIActivityTypePostToTencentWeibo,
        //                UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMail,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint]
        //            //
        //
        //            self.presentViewController(activityVC, animated: true, completion: nil)
        //
        //
        //        }
        //
        //
        //
        //
        
        
    }
    
    func showImageFullscreen(sender: UIGestureRecognizer){
        println("Presenting Likers, ya heard.")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let imView = mainStoryboard.instantiateViewControllerWithIdentifier("Image_focus_controller") as! ImageFocusController
        
        var daLink = "none"
        
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        //
        //        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        //
        //        if(indCell?.tag == 100){
        //            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
        //
        //        }
        //        if(indCell?.tag == 200){
        //            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
        //
        //           daLink = gotCell.imageLink
        //        }
        //
        //        imView.imageLink = daLink
        //
        //         self.presentViewController(imView, animated: true, completion: nil)
        
    }
    
    func showLikers(sender: UIGestureRecognizer){
        
        println("Presenting Likers, ya heard.")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let likeView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_likers_id") as! CommentLikersViewController
        
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        
        //        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        //
        //        if(indCell?.tag == 100){
        //            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
        //
        //            likeView.sentLocation = currentUserLocation
        //            likeView.commentID = gotCell.comment_id
        //
        //            //profView.comment = gotCell.comment_label.text!
        //            // profView.userFBID = gotCell.user_id
        //
        //            //profView.userName = gotCell.author_label.text!
        //        }
        //        if(indCell?.tag == 200){
        //            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
        //
        //            likeView.sentLocation = currentUserLocation
        //            likeView.commentID = gotCell.comment_id
        //            //profView.comment = gotCell.comment_label.text!
        //            //profView.userFBID = gotCell.user_id
        //
        //            //profView.userName = gotCell.author_label.text!
        //        }
        //
        //
        //        self.presentViewController(likeView, animated: true, completion: nil)
        
    }
    
    func showReplies(sender: UIGestureRecognizer){
        
        println("SLKFJS:LDKFJ")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let repView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_reply_id") as! CommentReplyViewController
        
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        //
        //        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        //
        //        if(indCell?.tag == 100){
        //            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
        //
        //            repView.sentLocation = currentUserLocation
        //            repView.commentID = gotCell.comment_id
        //            //profView.comment = gotCell.comment_label.text!
        //            // profView.userFBID = gotCell.user_id
        //
        //            //profView.userName = gotCell.author_label.text!
        //        }
        //        if(indCell?.tag == 200){
        //            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
        //
        //            repView.sentLocation = currentUserLocation
        //            repView.commentID = gotCell.comment_id
        //            //profView.comment = gotCell.comment_label.text!
        //            //profView.userFBID = gotCell.user_id
        //
        //            //profView.userName = gotCell.author_label.text!
        //        }
        //
        //
        //        self.presentViewController(repView, animated: true, completion: nil)
        
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
    
    
    
    func toggleCommentVote(sender:UIGestureRecognizer){
        //get the attached sender imageview
        
        var heartImage:AnyObject
        
        heartImage = sender.view!
        
        //var heartImage = sender.view? as UIImageView
        //get the main view
        
        //        var indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0))
        //
        //        if(indCell?.tag == 100){
        //
        //            var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as! custom_cell_no_images
        //
        //            var cID = cellView.comment_id
        //
        //
        //
        //
        //
        //            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_comment_vote")
        //            //START AJAX
        //            var request = NSMutableURLRequest(URL: url!)
        //            var session = NSURLSession.sharedSession()
        //            request.HTTPMethod = "POST"
        //
        //            let defaults = NSUserDefaults.standardUserDefaults()
        //            let userFBID = defaults.stringForKey("saved_fb_id") as String!
        //            var params = ["fbid":userFBID, "comment_id":String(cID)] as Dictionary<String, String>
        //
        //            var err: NSError?
        //            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        //            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //            request.addValue("application/json", forHTTPHeaderField: "Accept")
        //
        //            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        //                println("Response: \(response)")
        //                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        //                println("Body: \(strData)")
        //                var err: NSError?
        //                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
        //
        //
        //                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
        //                if(err != nil) {
        //                    println(err!.localizedDescription)
        //                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
        //                    println("Error could not parse JSON: '\(jsonStr)'")
        //                }
        //                else {
        //                    // The JSONObjectWithData constructor didn't return an error. But, we should still
        //
        //
        //
        //                    // check and make sure that json has a value using optional binding.
        //                    if let parseJSON = json {
        //                        dispatch_async(dispatch_get_main_queue(),{
        //                            //change the heart image
        //
        //
        //
        //                            var testVote = parseJSON["results"]![0]["vote"] as! String!
        //
        //                            if(testVote == "no"){
        //                                cellView.heart_icon?.image = UIImage(named: "heart_empty.png")
        //
        //                                //get heart label content as int
        //                                var curHVal = cellView.heart_label?.text?.toInt()
        //                                //get the heart label
        //                                self.voterValueCache[heartImage.tag] = String(curHVal! - 1)
        //                                cellView.heart_label?.text = String(curHVal! - 1)
        //                                //self.theJSON["results"]![100]["has_liked"] = "no" as AnyObject!?
        //                                self.voterCache[heartImage.tag] = "no"
        //                            }
        //                            else if(testVote == "yes"){
        //                                cellView.heart_icon.image = UIImage(named: "heart_full.png")
        //
        //                                //get heart label content as int
        //                                var curHVal = cellView.heart_label?.text?.toInt()
        //                                //get the heart label
        //                                self.voterValueCache[heartImage.tag] = String(curHVal! + 1)
        //                                cellView.heart_label?.text = String(curHVal! + 1)
        //                                self.voterCache[heartImage.tag] = "yes"
        //                                // self.theJSON["results"]![heartImage.tag]["has_liked"] = "yes" as [AnyObject]
        //                            }
        //                        })
        //
        //                    }
        //                    else {
        //                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
        //
        //                    }
        //                }
        //            })
        //            task.resume()
        //
        //
        //
        //        }
        //
        //        if(indCell?.tag == 200){
        //
        //            var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as! custom_cell
        //
        //            var cID = cellView.comment_id
        //
        //
        //
        //
        //
        //            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_comment_vote")
        //            //START AJAX
        //            var request = NSMutableURLRequest(URL: url!)
        //            var session = NSURLSession.sharedSession()
        //            request.HTTPMethod = "POST"
        //
        //            let defaults = NSUserDefaults.standardUserDefaults()
        //            let userFBID = defaults.stringForKey("saved_fb_id") as String!
        //            var params = ["fbid":userFBID, "comment_id":String(cID)] as Dictionary<String, String>
        //
        //            var err: NSError?
        //            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        //            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //            request.addValue("application/json", forHTTPHeaderField: "Accept")
        //
        //            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        //                println("Response: \(response)")
        //                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        //                println("Body: \(strData)")
        //                var err: NSError?
        //                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
        //
        //
        //                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
        //                if(err != nil) {
        //                    println(err!.localizedDescription)
        //                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
        //                    println("Error could not parse JSON: '\(jsonStr)'")
        //                }
        //                else {
        //                    // The JSONObjectWithData constructor didn't return an error. But, we should still
        //
        //
        //
        //                    // check and make sure that json has a value using optional binding.
        //                    if let parseJSON = json {
        //                        dispatch_async(dispatch_get_main_queue(),{
        //                            //change the heart image
        //
        //
        //
        //                            var testVote = parseJSON["results"]![0]["vote"] as! String!
        //
        //                            if(testVote == "no"){
        //                                cellView.heart_icon?.image = UIImage(named: "heart_empty.png")
        //
        //                                //get heart label content as int
        //                                var curHVal = cellView.heart_label?.text?.toInt()
        //                                //get the heart label
        //                                self.voterValueCache[heartImage.tag] = String(curHVal! - 1)
        //                                cellView.heart_label?.text = String(curHVal! - 1)
        //                                //save the new vote value in our array
        //                                self.voterCache[heartImage.tag] = "no"
        //                            }
        //                            else if(testVote == "yes"){
        //                                cellView.heart_icon?.image = UIImage(named: "heart_full.png")
        //
        //                                //get heart label content as int
        //                                var curHVal = cellView.heart_label?.text?.toInt()
        //                                //get the heart label
        //                                self.voterValueCache[heartImage.tag] = String(curHVal! + 1)
        //                                cellView.heart_label?.text = String(curHVal! + 1)
        //                                self.voterCache[heartImage.tag] = "yes"
        //                            }
        //                        })
        //
        //                    }
        //                    else {
        //                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
        //
        //                    }
        //                }
        //            })
        //            task.resume()
        //
        //
        //
        //        }
        //
    }
    
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        isBounce = true
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var currentOffset = scrollView.contentOffset.y;
        
        var test = self.oldScrollPost - currentOffset
        
        println("SCROLL:\(currentOffset)")
        println("SIZE:\(scrollView.contentSize.height)")
        println("FRAME:\(scrollView.frame.height)")
        if(test >= 0 ){
            
        }
        else{
            
            
            
        }
        
        
        self.oldScrollPost = currentOffset
        
        if(currentOffset > 0 && currentOffset < (scrollView.contentSize.height - scrollView.frame.height - 100)){
            animateBar(test)
        }
        
    }
    
    
    func animateBar(byNum: CGFloat){
        //        self.hashtagHolderTopLayoutConstraint.constant = -1*currentOffset
        var theChanger = byNum
        let initVal:CGFloat = 0//10
        let maxVal = 0 - self.backgroundProfileImage.frame.height - self.hashtagHolder.frame.height - 20
        //let maxVal = 0 - self.postLabelHolder.frame.origin
        
        
        if(byNum > 0){
            byNum*50.0
        }
        theChanger = theChanger*1.0
        
        topLayoutConstraint.constant = topLayoutConstraint.constant + theChanger
        
        if(topLayoutConstraint.constant < maxVal){
            topLayoutConstraint.constant = maxVal
        }
        else if(topLayoutConstraint.constant > initVal){
            topLayoutConstraint.constant = initVal
        }
        
        //        UIView.animateWithDuration(0.01, delay: 0.0, options: .BeginFromCurrentState, animations: {
        //            self.view.layoutIfNeeded()
        //            }, completion: nil)
        
    }
    
    
    
    
    func removeLoadingScreen(){
        //self.loadingScreen.alpha = 0.0
        
        for view in self.view.subviews {
            if(view.tag == 999){
                view.removeFromSuperview()
            }
        }
    }
    
    
    
    func followUser(){
        
        //self.followButton.titleLabel?.text = "..."
        self.followButton.setTitle("...", forState: UIControlState.Normal)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_user_follow")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["gUser_fbID":fbid, "iUser_fbID":fbid] as Dictionary<String, String>
        
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
                
                if let parseJSON = json {
                    
                    let valTest = parseJSON["results"]![0]["value"] as! String!
                    
                    if(valTest == "yes"){//user did just follow
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.followButton.titleLabel?.text = "UNFOLLOW"
                            self.followButton.setTitle("UNFOLLOW", forState: UIControlState.Normal)
                            
                            //self.followButton.titleLabel?.text = "done"
                            //self.followButton.setTitle("unfollow", forState: UIControlState.Normal)
                            // self.followButton.setImage(UIImage(named: "Unfollow.png"), forState: UIControlState.Normal)
                        })
                    }
                    else{
                        //user did just unfollow
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            self.followButton.setTitle("FOLLOW", forState: UIControlState.Normal)
                            //self.followButton.titleLabel?.text = "FOLLOW"
                            //self.followButton.titleLabel?.text = "done"
                            //self.followButton.setTitle("follow", forState: UIControlState.Normal)
                            //  self.followButton.setImage(UIImage(named: "Follow.png"), forState: UIControlState.Normal)
                        })
                        
                    }
                    
                }
                else {
                    
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
    }
    
    func blockUser(){
        println("CLICK BLOCK USER")
    }
    
    
    
}