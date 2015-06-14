//
//  LocationPeakViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 5/25/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit
import MapKit


class LocationPeakViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var titleItem:UINavigationItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var navBar: UINavigationBar!
    var locationName = "..."
    var latLon = "none"
    var savedFBID = "none"
    var hasLoaded = false
    var theJSON: NSDictionary!
    var numOfCells = 0
    
    var imageCache = [String : UIImage]()
    var voterCache = [Int : String]()
    var voterValueCache = [Int : String]()
    var userImageCache = [String: UIImage]()
    var isBounce:Bool! = false
    var oldScrollPost:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.zoomEnabled = false
        self.mapView.scrollEnabled = false
        self.mapView.userInteractionEnabled = false
        
        
        tableView.estimatedRowHeight = 500.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        titleItem.title = locationName
        
        var fullNameArr = latLon.componentsSeparatedByString(", ")
        var latS: String = fullNameArr[0]
        var lonS: String  = fullNameArr[1]
        
        
        let latF = (latS as NSString).doubleValue
        let lonF = (lonS as NSString).doubleValue
        
        
        let initialLocation = CLLocation(latitude:latF, longitude:lonF)
        let loc1 = CLLocationCoordinate2D(latitude:latF, longitude:lonF)
        centerMapOnLocation(initialLocation)
        
        let anno = MKPointAnnotation()
        
//        UILabel *attributionLabel = [mapView.subviews objectAtIndex:1];
//        attributionLabel.center = CGPointMake(attributionLabel.center.x, attributionLabel.center.y - 44.0f);

        
        //mLabel.centerCoordinate = CGPointMake(mLabel.centerCoordinate.latitude, mLabel.centerCoordinate.longitude - 44.0)
        anno.title = "Hello"
        anno.coordinate = loc1
        
       
        mapView.addAnnotation(anno)
        

        getLocalComments()
        
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
    
    
    func removeLoadingScreen(){
        //self.loadingScreen.alpha = 0.0
        
        for view in self.view.subviews {
            if(view.tag == 999){
                view.removeFromSuperview()
            }
        }
    }

    
    
    let regionRadius: CLLocationDistance = 200
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    

    
    override func viewDidLayoutSubviews() {
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        self.tableView.separatorColor = color
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        self.tableView.separatorInset.left = 0
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        //self.tableView.awakeFromNib()
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
        let testImage = theJSON["results"]![indexPath.row]["image"] as! String!
        
        let testType = theJSON["results"]![indexPath.row]["type"] as! String!
        //1 is comment with no image
        //2 is comment with image
        //3 islocation summary
        
        if(testImage == "none"){
            var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell_no_images") as! custom_cell_no_images
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
            cell.imageLink = testImage
            cell.tag = 100
            
            
            var numLiked = voterValueCache[indexPath.row] as String!
            //set the cell contents with the ajax data
            cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as! String!
            cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as! String!
            cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as! String!
//            cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as! String!
            cell.heart_label?.text = numLiked//theJSON["results"]![indexPath.row]["hearts"] as! String!
            cell.time_label?.text = theJSON["results"]![indexPath.row]["time"] as! String!
            cell.replyNumLabel?.text = theJSON["results"]![indexPath.row]["numComments"] as! String!
            //            let myMutableString = NSMutableAttributedString(string: "Herro", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            //
            //            let myMutableString2 = NSMutableAttributedString(string: "World", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 8.0)!])
            //
            //            myMutableString.appendAttributedString(myMutableString2)
            //
            
            //     cell.comment_label?.attributedText = myMutableString
            
            //var doit: NSAttributedString! = self.parseHTMLString(cell.comment_label?.text!)
            
            let asdfasd = cell.comment_label?.text!
            
            var gotURL = self.parseHTMLString(asdfasd!)
            
            println("OH YEAH:\(gotURL)")
            
            if(gotURL.count == 0){
                println("NO SHOW")
                cell.urlLink = "none"
            }
            else{
                println("LAST TIME BuDDY:\(gotURL.last)")
                cell.urlLink = gotURL.last! as! String
                
                let linkTap = UITapGestureRecognizer(target: self, action:Selector("clickComLink:"))
                // 4
                linkTap.delegate = self
                cell.comment_label?.tag = indexPath.row
                cell.comment_label?.userInteractionEnabled = true
                cell.comment_label?.addGestureRecognizer(linkTap)
                
            }
            
            
            
            let userFBID = theJSON["results"]![indexPath.row]["user_id"] as! String!
            cell.user_id = userFBID
            
            // cell.userImage.frame = CGRectMake(20, 20, 20, 20)
            let testUserImg = "http://graph.facebook.com/\(userFBID)/picture?type=small"
            //     let imageLink = "http://graph.facebook.com/\(userFBID)/picture?type=small"
            //let url = NSURL(string: imageLink)
            // let data2 = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            // comImage.image = UIImage(data: data!)
            
            //  cell.userImage.image = UIImage(data:data2!)
            
            
            
            //GET TEH USER IMAGE
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
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell_no_images {
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
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell_no_images {
                        cellToUpdate.userImage?.image = upimage
                    }
                })
            }
            
            
            
            
            
            
            
            
            let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap.delegate = self
            cell.author_label?.tag = indexPath.row
            cell.author_label?.userInteractionEnabled = true
            cell.author_label?.addGestureRecognizer(authorTap)
            
            let authorTap2 = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap2.delegate = self
            cell.userImage?.tag = indexPath.row
            cell.userImage?.userInteractionEnabled = true
            cell.userImage?.addGestureRecognizer(authorTap2)
            
            
            
            let likersTap = UITapGestureRecognizer(target: self, action:Selector("showLikers:"))
            likersTap.delegate = self
            cell.likerButtonLabel?.tag = indexPath.row
            cell.likerButtonLabel?.userInteractionEnabled = true
            cell.likerButtonLabel?.addGestureRecognizer(likersTap)
            
            
            
            
            let repliesTap = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap.delegate = self
            cell.replyButtonImage?.tag = indexPath.row
            cell.replyButtonImage?.userInteractionEnabled = true
            cell.replyButtonImage?.addGestureRecognizer(repliesTap)
            
            let repliesTap2 = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap2.delegate = self
            cell.replyButtonLabel?.tag = indexPath.row
            cell.replyButtonLabel?.userInteractionEnabled = true
            cell.replyButtonLabel?.addGestureRecognizer(repliesTap2)
            
            let repliesTap3 = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap3.delegate = self
            cell.replyNumLabel?.tag = indexPath.row
            cell.replyNumLabel?.userInteractionEnabled = true
            cell.replyNumLabel?.addGestureRecognizer(repliesTap3)
            
            
            
            
            
            //
            
            //
            //
            let shareTap = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            shareTap.delegate = self
            cell.shareLabel?.tag = indexPath.row
            cell.shareLabel?.userInteractionEnabled = true
            cell.shareLabel?.addGestureRecognizer(shareTap)
            // cell.bringSubviewToFront(cell.shareLabel)
            // cell.contentView.bringSubviewToFront(cell.shareLabel)
            
            let shareTap2 = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            shareTap2.delegate = self
            cell.shareButton?.tag = indexPath.row
            cell.shareButton?.userInteractionEnabled = true
            cell.shareButton?.addGestureRecognizer(shareTap2)
            // cell.bringSubviewToFront(cell.shareButton)
            //
            
            //find out if the user has liked the comment or not
            //var hasLiked = theJSON["results"]![indexPath.row]["has_liked"] as! String!
             var hasLiked = voterCache[indexPath.row] as String!
            
            
            if(hasLiked == "yes"){
                cell.heart_icon?.userInteractionEnabled = true
                cell.heart_icon?.image = UIImage(named: "heart_full.png")
                
                let voteDown = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
                // 4
                voteDown.delegate = self
                cell.heart_icon?.tag = indexPath.row
                cell.heart_icon?.addGestureRecognizer(voteDown)
                
                
            }
            else if(hasLiked == "no"){
                cell.heart_icon?.userInteractionEnabled = true
                cell.heart_icon?.image = UIImage(named: "heart_empty.png")
                
                let voteUp = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
                // 4
                voteUp.delegate = self
                cell.heart_icon?.tag = indexPath.row
                cell.heart_icon?.addGestureRecognizer(voteUp)
            }
            
            
            
            let voteUp2 = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
            cell.likerButtonHolder?.userInteractionEnabled = true
            voteUp2.delegate = self
            cell.likerButtonHolder?.tag = indexPath.row
            cell.likerButtonHolder?.addGestureRecognizer(voteUp2)
            
            
            
            
            
            return cell
            
            
            
        }
        else if(testType == "2"){
            //image
            var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell") as! custom_cell
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
            cell.imageLink = testImage
            cell.tag = 200
            
            
            
            var numLiked = voterValueCache[indexPath.row] as String!
            //set the cell contents with the ajax data
            cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as! String!
            cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as! String!
            cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as! String!
            cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as! String!
            cell.heart_label?.text = numLiked//theJSON["results"]![indexPath.row]["hearts"] as! String!
            cell.time_label?.text = theJSON["results"]![indexPath.row]["time"] as! String!
            cell.replyNumLabel?.text = theJSON["results"]![indexPath.row]["numComments"] as! String!
            let myMutableString = NSMutableAttributedString(string: "Herro", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            
            let myMutableString2 = NSMutableAttributedString(string: "World", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 8.0)!])
            
            myMutableString.appendAttributedString(myMutableString2)
            
            
            //     cell.comment_label?.attributedText = myMutableString
            
            //var doit: NSAttributedString! = self.parseHTMLString(cell.comment_label?.text!)
            
            let asdfasd = cell.comment_label?.text!
            
            var gotURL = self.parseHTMLString(asdfasd!)
            
            println("OH YEAH:\(gotURL)")
            
            if(gotURL.count == 0){
                println("NO SHOW")
                cell.urlLink = "none"
            }
            else{
                println("LAST TIME BuDDY:\(gotURL.last)")
                cell.urlLink = gotURL.last! as! String
                
                let linkTap = UITapGestureRecognizer(target: self, action:Selector("clickComLink:"))
                // 4
                linkTap.delegate = self
                cell.comment_label?.tag = indexPath.row
                cell.comment_label?.userInteractionEnabled = true
                cell.comment_label?.addGestureRecognizer(linkTap)
                
            }
            
            let userFBID = theJSON["results"]![indexPath.row]["user_id"] as! String!
            cell.user_id = userFBID
            let testUserImg = "http://graph.facebook.com/\(userFBID)/picture?type=small"
            //     let imageLink = "http://graph.facebook.com/\(userFBID)/picture?type=small"
            //    let url = NSURL(string: imageLink)
            //   let data2 = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            //            comImage.image = UIImage(data: data!)
            
            // cell.userImage.image = UIImage(data:data2!)
            
            
            
            //GET TEH USER IMAGE
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
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell {
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
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell {
                        cellToUpdate.userImage?.image = upimage
                    }
                })
            }
            
            
            
            
            
            
            
            
            let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap.delegate = self
            cell.author_label?.tag = indexPath.row
            cell.author_label?.userInteractionEnabled = true
            cell.author_label?.addGestureRecognizer(authorTap)
            
            
            
            let authorTap2 = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap2.delegate = self
            cell.userImage?.tag = indexPath.row
            cell.userImage?.userInteractionEnabled = true
            cell.userImage?.addGestureRecognizer(authorTap2)
            
            
            
            let likersTap = UITapGestureRecognizer(target: self, action:Selector("showLikers:"))
            likersTap.delegate = self
            cell.likerButtonLabel?.tag = indexPath.row
            cell.likerButtonLabel?.userInteractionEnabled = true
            cell.likerButtonLabel?.addGestureRecognizer(likersTap)
            
            
            
            
            let repliesTap = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap.delegate = self
            cell.replyButtonImage?.tag = indexPath.row
            cell.replyButtonImage?.userInteractionEnabled = true
            cell.replyButtonImage?.addGestureRecognizer(repliesTap)
            
            let repliesTap2 = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap2.delegate = self
            cell.replyButtonLabel?.tag = indexPath.row
            cell.replyButtonLabel?.userInteractionEnabled = true
            cell.replyButtonLabel?.addGestureRecognizer(repliesTap2)
            
            let repliesTap3 = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap3.delegate = self
            cell.replyNumLabel?.tag = indexPath.row
            cell.replyNumLabel?.userInteractionEnabled = true
            cell.replyNumLabel?.addGestureRecognizer(repliesTap3)
            
            
            
            
            
            //
            
            //
            //
            let shareTap = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            shareTap.delegate = self
            cell.shareLabel?.tag = indexPath.row
            cell.shareLabel?.userInteractionEnabled = true
            cell.shareLabel?.addGestureRecognizer(shareTap)
            // cell.bringSubviewToFront(cell.shareLabel)
            // cell.contentView.bringSubviewToFront(cell.shareLabel)
            
            let shareTap2 = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            shareTap2.delegate = self
            cell.shareButton?.tag = indexPath.row
            cell.shareButton?.userInteractionEnabled = true
            cell.shareButton?.addGestureRecognizer(shareTap2)
            // cell.bringSubviewToFront(cell.shareButton)
            //
            
            //find out if the user has liked the comment or not
            //var hasLiked = theJSON["results"]![indexPath.row]["has_liked"] as! String!
            var hasLiked = voterCache[indexPath.row] as String!
            
            if(hasLiked == "yes"){
                cell.heart_icon?.userInteractionEnabled = true
                cell.heart_icon?.image = UIImage(named: "heart_full.png")
                
                let voteDown = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
                // 4
                voteDown.delegate = self
                cell.heart_icon?.tag = indexPath.row
                cell.heart_icon?.addGestureRecognizer(voteDown)
                
                
            }
            else if(hasLiked == "no"){
                cell.heart_icon?.userInteractionEnabled = true
                cell.heart_icon?.image = UIImage(named: "heart_empty.png")
                
                let voteUp = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
                // 4
                voteUp.delegate = self
                cell.heart_icon?.tag = indexPath.row
                cell.heart_icon?.addGestureRecognizer(voteUp)
            }
            
            
            let voteUp2 = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
            cell.likerButtonHolder?.userInteractionEnabled = true
            voteUp2.delegate = self
            cell.likerButtonHolder?.tag = indexPath.row
            cell.likerButtonHolder?.addGestureRecognizer(voteUp2)
            
            //give a loading gif to UI
            var urlgif = NSBundle.mainBundle().URLForResource("loader2", withExtension: "gif")
            var imageDatagif = NSData(contentsOfURL: urlgif!)
            
            
            let imagegif = UIImage.animatedImageWithData(imageDatagif!)
            
            cell.comImage.image = imagegif
            
            
            
            //GET TEH COMMENT IMAGE
            var image = self.imageCache[testImage]
            if( image == nil ) {
                // If the image does not exist, we need to download it
                var imgURL: NSURL = NSURL(string: testImage)!
                
                // Download an NSData representation of the image at the URL
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        image = UIImage(data: data)
                        
                        // Store the image in to our cache
                        self.imageCache[testImage] = image
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell {
                                cellToUpdate.comImage.image = image
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
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell {
                        cellToUpdate.comImage?.image = image
                    }
                })
            }
            
            
            
            
            
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell_location") as! custom_cell_location
            
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
            cell.tag = 300
            
            
            
            //            @IBOutlet var locationLabel: UILabel!
            //
            //            @IBOutlet var user1NameLabel: UILabel!
            //            @IBOutlet var user2NameLabel: UILabel!
            //            @IBOutlet var user3NameLabel: UILabel!
            //            @IBOutlet var user1Pic:UIImageView!
            //            @IBOutlet var user2Pic:UIImageView!
            //            @IBOutlet var user3Pic:UIImageView!
            //
            //
            //            @IBOutlet var locPic1:UIImageView!
            //            @IBOutlet var locPic2:UIImageView!
            //            @IBOutlet var locPic3:UIImageView!
            //            @IBOutlet var locPic4:UIImageView!
            
            cell.latLon = theJSON["results"]![indexPath.row]["location"] as! String!
            cell.locationLabel?.text = theJSON["results"]![indexPath.row]["locationAddress"] as! String!
            
            
            cell.user1NameLabel?.text = theJSON["results"]![indexPath.row]["user1Name"] as! String!
            let user1FBID = theJSON["results"]![indexPath.row]["user1fb"] as! String!
            let testUser1Img = "http://graph.facebook.com/\(user1FBID)/picture?type=small"
            let url1 = NSURL(string: testUser1Img)
            let data1 = NSData(contentsOfURL: url1!) //make sure your image in this url
            cell.user1Pic.image = UIImage(data:data1!)
            
            
            cell.user2NameLabel?.text = theJSON["results"]![indexPath.row]["user2Name"] as! String!
            let user2FBID = theJSON["results"]![indexPath.row]["user2fb"] as! String!
            let testUser2Img = "http://graph.facebook.com/\(user2FBID)/picture?type=small"
            let url2 = NSURL(string: testUser2Img)
            let data2 = NSData(contentsOfURL: url2!) //make sure your image in this url
            cell.user2Pic.image = UIImage(data:data2!)
            
            
            cell.user3NameLabel?.text = theJSON["results"]![indexPath.row]["user3Name"] as! String!
            let user3FBID = theJSON["results"]![indexPath.row]["user3fb"] as! String!
            let testUser3Img = "http://graph.facebook.com/\(user3FBID)/picture?type=small"
            let url3 = NSURL(string: testUser3Img)
            let data3 = NSData(contentsOfURL: url3!) //make sure your image in this url
            cell.user3Pic.image = UIImage(data:data3!)
            
            let picLink1 = theJSON["results"]![indexPath.row]["pic1Link"] as! String!
            let picURL1 = NSURL(string: picLink1)
            let picData1 = NSData(contentsOfURL: picURL1!)
            cell.locPic1.image = UIImage(data:picData1!)
            
            let picLink2 = theJSON["results"]![indexPath.row]["pic2Link"] as! String!
            let picURL2 = NSURL(string: picLink2)
            let picData2 = NSData(contentsOfURL: picURL2!)
            cell.locPic2.image = UIImage(data:picData2!)
            
            let picLink3 = theJSON["results"]![indexPath.row]["pic3Link"] as! String!
            let picURL3 = NSURL(string: picLink3)
            let picData3 = NSData(contentsOfURL: picURL3!)
            cell.locPic3.image = UIImage(data:picData3!)
            
            let picLink4 = theJSON["results"]![indexPath.row]["pic4Link"] as! String!
            let picURL4 = NSURL(string: picLink4)
            let picData4 = NSData(contentsOfURL: picURL4!)
            cell.locPic4.image = UIImage(data:picData4!)
            
            return cell
        }
    }

    
    
    
    
    override func viewDidAppear(animated: Bool) {

    }
    

    
    
    
    
    
    func getLocalComments(){
        
        
        //let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_location_comments")
        
        
        showLoadingScreen()
        
        //peak cuppies and joe
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_2")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "recentLocation":latLon] as Dictionary<String, String>
        
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

                self.removeLoadingScreen()
            }
                
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                
                
                self.removeLoadingScreen()
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
        
        for index in 0...finNum{
            self.voterCache[index] = theJSON["results"]![index]["has_liked"] as? String
            self.voterValueCache[index] = theJSON["results"]![index]["hearts"] as? String
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
    
    func showLikers(sender: UIGestureRecognizer){
        
        println("Presenting Likers, ya heard.")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let likeView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_likers_id") as! CommentLikersViewController
        
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
            
            likeView.sentLocation = latLon
            likeView.commentID = gotCell.comment_id
            
            //profView.comment = gotCell.comment_label.text!
            // profView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
            
            likeView.sentLocation = latLon
            likeView.commentID = gotCell.comment_id
            //profView.comment = gotCell.comment_label.text!
            //profView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
        }
        
        
        self.presentViewController(likeView, animated: true, completion: nil)
        
    }
    
    func showReplies(sender: UIGestureRecognizer){
        
        println("SLKFJS:LDKFJ")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let repView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_reply_id") as! CommentReplyViewController
        
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
            
            repView.sentLocation = latLon
            repView.commentID = gotCell.comment_id
            //profView.comment = gotCell.comment_label.text!
            // profView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
            
            repView.sentLocation = latLon
            repView.commentID = gotCell.comment_id
            //profView.comment = gotCell.comment_label.text!
            //profView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
        }
        
        
        self.presentViewController(repView, animated: true, completion: nil)
        
    }
    
    
    
    func clickComLink(sender: UIGestureRecognizer){
        var sharedButton:AnyObject
        
        sharedButton = sender.view!
        
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell_no_images
            
            let link = gotCell.urlLink
            
            UIApplication.sharedApplication().openURL(NSURL(string:link)!)
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell
            
            let link = gotCell.urlLink
            
            UIApplication.sharedApplication().openURL(NSURL(string:link)!)
            
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
        
        
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell_no_images
            
            
            let shareCom = gotCell.comment_label.text as String!
            let shareAuth = gotCell.author_label.text as String!
            
            let giveMess = "'\(shareCom)'  @\(shareAuth) \n\n @SoLoCoHive (http://apple.co/1yTV9Fj)"
            
            
            
            
            let objectsToShare = [giveMess]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToTencentWeibo,
                UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMail,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint]
            //
            
            self.presentViewController(activityVC, animated: true, completion: nil)
            
            
            
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell
            
            
            let shareCom = gotCell.comment_label.text as String!
            let shareAuth = gotCell.author_label.text as String!
            
            let giveMess = "'\(shareCom)'  @\(shareAuth) \n\n @SoLoCoHive (http://apple.co/1yTV9Fj)"
            let hiveSite = NSURL(string: "http://apple.co/1yTV9Fj")
            
            let shareImage = gotCell.comImage?.image as UIImage!
            
            let objectsToShare = [giveMess, shareImage]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToTencentWeibo,
                UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMail,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint]
            //
            
            self.presentViewController(activityVC, animated: true, completion: nil)
            
            
        }
        
        
        
        
        
        
    }
    
    
    func toggleCommentVote(sender:UIGestureRecognizer){
        //get the attached sender imageview
        
        var heartImage:AnyObject
        
        heartImage = sender.view!
        
        //var heartImage = sender.view? as UIImageView
        //get the main view
        
        var indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            
            var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as! custom_cell_no_images
            
            var cID = cellView.comment_id
            
            
            
            
            
            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_comment_vote")
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
                            
                            
                            
                            var testVote = parseJSON["results"]![0]["vote"] as! String!
                            
                            if(testVote == "no"){
                                cellView.heart_icon?.image = UIImage(named: "heart_empty.png")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                self.voterValueCache[heartImage.tag] = String(curHVal! - 1)
                                cellView.heart_label?.text = String(curHVal! - 1)
                                //self.theJSON["results"]![100]["has_liked"] = "no" as AnyObject!?
                                self.voterCache[heartImage.tag] = "no"
                            }
                            else if(testVote == "yes"){
                                cellView.heart_icon.image = UIImage(named: "heart_full.png")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                self.voterValueCache[heartImage.tag] = String(curHVal! + 1)
                                cellView.heart_label?.text = String(curHVal! + 1)
                                self.voterCache[heartImage.tag] = "yes"
                               // self.theJSON["results"]![heartImage.tag]["has_liked"] = "yes" as [AnyObject]
                            }
                        })
                        
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        
                    }
                }
            })
            task.resume()
            
            
            
        }
        
        if(indCell?.tag == 200){
            
            var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as! custom_cell
            
            var cID = cellView.comment_id
            
            
            
            
            
            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_comment_vote")
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
                            
                            
                            
                            var testVote = parseJSON["results"]![0]["vote"] as! String!
                            
                            if(testVote == "no"){
                                cellView.heart_icon?.image = UIImage(named: "heart_empty.png")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                self.voterValueCache[heartImage.tag] = String(curHVal! - 1)
                                cellView.heart_label?.text = String(curHVal! - 1)
                                //save the new vote value in our array
                                self.voterCache[heartImage.tag] = "no"
                            }
                            else if(testVote == "yes"){
                                cellView.heart_icon?.image = UIImage(named: "heart_full.png")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                self.voterValueCache[heartImage.tag] = String(curHVal! + 1)
                                cellView.heart_label?.text = String(curHVal! + 1)
                                self.voterCache[heartImage.tag] = "yes"
                            }
                        })
                        
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        
                    }
                }
            })
            task.resume()
            
            
            
        }
        
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
            //  animateBarDown()
        }
        else{
            //    animateBarUp()
            
        }
        
        
        self.oldScrollPost = currentOffset
        
        if(currentOffset > 20 && currentOffset < (scrollView.contentSize.height - scrollView.frame.height - 100)){
            animateBar(test)
        }
        
    }
    
    func animateBar(byNum: CGFloat){
    
        //let initVal:CGFloat = -20
        let initVal:CGFloat = 0
       // let maxVal = 0 - self.mapView.frame.height
        let maxVal = 20 - self.mapView.frame.height
        
        if(byNum > 0){
            byNum*2.5
        }
        
        topLayoutConstraint.constant = topLayoutConstraint.constant + byNum
        
        if(topLayoutConstraint.constant < maxVal){
            topLayoutConstraint.constant = maxVal
        }
        else if(topLayoutConstraint.constant > initVal){
            topLayoutConstraint.constant = initVal
        }
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}