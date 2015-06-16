//
//  ImageFocusController.swift
//  layout_1
//
//  Created by Rijul Gupta on 6/14/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//
import UIKit



class ImageFocusController: UIViewController, UITabBarDelegate, UIScrollViewDelegate {
    
    
    // @IBOutlet var commentLabel: UILabel!
    //@IBOutlet var authorLabel: UILabel!
    //@IBOutlet var authorPicture: UIImageView!
    //@IBOutlet var commentView: UITextView!
    //@IBOutlet var replyHolderView: UIView!
    @IBOutlet var tableView: UITableView! //holds replies and likes
    @IBOutlet var imageFocus: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
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

    
    var sentLocation = "none"
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.commentLabel.text = comment
        //self.commentView.text = comment
        // self.commentView.text = "S:DKFJS:KDFJS:KDFJ:SLKJF:LSKDFJ SDF:LKSDJF:KS DFKSDF:LKSDF:LKDF:SDJF:KSLDF:SLDFKJS:LDKFJS:LFDKJS:LDKFS:LDFKJ"
        //self.authorLabel.text = author
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("reload_table"), userInfo: nil, repeats: false)
        let defaults = NSUserDefaults.standardUserDefaults()
        savedFBID = defaults.stringForKey("saved_fb_id")!
        
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        
       // scrollView.contentMode = UIViewContentMode.ScaleAspectFill
        
        let url = NSURL(string: imageLink)
        // let url = NSURL(string: "http://graph.facebook.com/4/picture?width=200&height=200")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check

        

       // scrollView.addSubview(imageView)
       // scrollView.contentSize = imageView.frame.size
        //scrollView.contentSize = CGSizeMake(200, 200)
        
        
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageFocus
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )

        
      
        
        
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

        
        let url = NSURL(string: imageLink)
       // let url = NSURL(string: "http://graph.facebook.com/4/picture?width=200&height=200")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        imageFocus.image = UIImage(data: data!)
        //println("THIS IS THE SENT LOCATION:\(sentLocation)")

        
        //imageFocus.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)
        //imageFocus.sizeToFit()
      //  imageFocus.contentMode = UIViewContentMode.ScaleToFill
      //  scrollView.contentSize = imageFocus.frame.size
        let w = self.view.frame.size.width - 16.0
        scrollView.contentSize = CGSizeMake(w, w)
    }

    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

  
}