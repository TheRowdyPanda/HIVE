//
//  PersonTableViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 7/20/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit

class PersonTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var userImageCache = [String: UIImage]()
 
    var refreshControl:UIRefreshControl!
    
    
    var hasLoaded = false
    var theJSON: NSDictionary!
    var savedFBID = "none"
    var numOfCells = 0
    var oldScrollPost:CGFloat = 0.0
    let fakeNames = ["Name is 1", "John SMith", "Charlse Montgoery", "Victor Knermit", "Name is 1", "John SMith", "Charlse Montgoery", "Victor Knermit", "Name is 1", "John SMith", "Charlse Montgoery", "Victor Knermit", "Name is 1", "John SMith", "Charlse Montgoery", "Victor Knermit"]
    //var radValue = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        savedFBID =
            defaults.stringForKey("saved_fb_id")!
        
        loadPeople()
        
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        self.tableView.separatorColor = color
        //self.tableView.separatorStyle
        self.tableView.separatorInset.left = 0
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
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
        
            var cell = tableView.dequeueReusableCellWithIdentifier("person_cell_id") as! custom_cell_person
        
        
        
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
            cell.tag = 100
            
            
            
            //set the cell contents with the ajax data
            cell.name_label?.text = theJSON["results"]![indexPath.row]["userName"] as! String!
            cell.comment_id = "22"//theJSON["results"]![indexPath.row]["c_id"] as! String!
            cell.friends_label?.text = theJSON["results"]![indexPath.row]["friends"] as! String!
            cell.hashtags = theJSON["results"]![indexPath.row]["hashtags"] as! [(NSString)]
            var yPos = 0.0
            
            let userFBID = theJSON["results"]![indexPath.row]["userID"] as! String!

            // cell.userImage.frame = CGRectMake(20, 20, 20, 20)
            let testUserImg = "http://graph.facebook.com/\(userFBID)/picture?type=small"
            
            let url = NSURL(string: testUserImg)
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            cell.userImage.image = UIImage(data: data!)
            
            
        
        for i in 0...(cell.hashtags.count - 1){
            
            var title = cell.hashtags[i]
            let width = Int(title.length)*12
            var xpos = 0.0
            var widthSpacing = 10.0
            if(cell.hashtagButtons.count > 0){
                let holder = cell.hashtagButtons.last! as UIButton!
                xpos = Double(holder.frame.origin.x) + Double(holder.frame.width) + widthSpacing;
            }
            
            cell.widthFiller += width + Int(widthSpacing)
            
            if(Double(cell.widthFiller) > Double(cell.contentView.frame.width/2.60)){
                cell.widthFiller = width + Int(widthSpacing)
                yPos += 50.0
                xpos = 0.0
            }
            if(cell.hasLoadedInfo == false){
            var newButton = UIButton(frame: CGRect(x: Int(xpos), y: Int(yPos), width: width, height: 35))
            newButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            
            newButton.setTitle(title as String, forState: UIControlState.Normal)
            cell.hashtagHolder.addSubview(newButton)
            cell.hashtagButtons.append(newButton)

            
            }
            else{
                cell.hashtagButtons[i]?.setTitle(title as String, forState: UIControlState.Normal)
            }
            
            
        }

        
        
            cell.userImage.backgroundColor = UIColor.redColor()
            cell.hasLoadedInfo = true
        
//
//
            return cell
            
            
            

    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
//        
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as! ThirdViewController
//        //
//        
//        
//        let indCell = tableView.cellForRowAtIndexPath(indexPath)
//        
//        let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("main_view_scene_id") as! ViewController
//        
//        if(indCell?.tag == 100){
//            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell_no_images
//            
//            comView.sentLocation = mainView.currentUserLocation
//            comView.commentID = gotCell.comment_id
//            
//        }
//        if(indCell?.tag == 200){
//            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell
//            
//            comView.sentLocation = mainView.currentUserLocation
//            comView.commentID = gotCell.comment_id
//            
//        }
//        
//        
//        
//        self.presentViewController(comView, animated: true, completion: nil)
    }
    
    
    
    func loadPeople(){
        
        
        showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_people")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        var params = ["gfbid":fbid] as Dictionary<String, String>
        
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
            
            
            self.removeLoadingScreen()
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
    
    
    
    
//    
//     func writeVoterCache(){
//        
//        let finNum = (theJSON["results"]!.count - 1)
//        
//        if(finNum >= 0){
//            
//            for index in 0...finNum{
//                self.voterCache[index] = theJSON["results"]![index]["has_liked"] as? String
//                self.voterValueCache[index] = theJSON["results"]![index]["hearts"] as? String
//            }
//        }
//        
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