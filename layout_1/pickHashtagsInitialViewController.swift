//
//  pickHashtagsInitialViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 7/19/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class pickHashtagsInitialViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @IBOutlet var hashtagScrollHolder:UIScrollView!
    var fakeHashtags = ["MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj", "Oijfodsijfoidj", "ofjijf", "Ijfi", "OSIDJFOSFSDF", "SODJFOSI", "OSIDJF", "OSIDJFOSIDJF", "ISJDFOISJ", "MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj", "Oijfodsijfoidj", "ofjijf", "Ijfi", "OSIDJFOSFSDF", "SODJFOSI", "OSIDJF", "OSIDJFOSIDJF", "ISJDFOISJ", "MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj", "Oijfodsijfoidj", "ofjijf", "Ijfi", "OSIDJFOSFSDF", "SODJFOSI", "OSIDJF", "OSIDJFOSIDJF", "ISJDFOISJ", "MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj", "Oijfodsijfoidj", "ofjijf", "Ijfi", "OSIDJFOSFSDF", "SODJFOSI", "OSIDJF", "OSIDJFOSIDJF", "ISJDFOISJ", "MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj", "Oijfodsijfoidj", "ofjijf", "Ijfi", "OSIDJFOSFSDF", "SODJFOSI", "OSIDJF", "OSIDJFOSIDJF", "ISJDFOISJ", "MarioKart", "InsideOut", "YoMomma", "Fakeroi1", "Ifjofj", "Oijfodsijfoidj", "ofjijf", "Ijfi", "OSIDJFOSFSDF", "SODJFOSI", "OSIDJF", "OSIDJFOSIDJF", "ISJDFOISJ"]
    var hashtagViews = [UIView?]()
    var hashtagButtons = [UIButton?]()
    var widthFiller = 0
    var yPos = 10.0
    var hasStartedClick = false
    var isScrolling = false
    var hasSelectedAHashtag = false
    var theJSON: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellowColor()
        
        for i in 0...(self.fakeHashtags.count - 1){
            self.createHashtag(fakeHashtags[i]);
            }
        
        //centerHashtags()
        
        let contentSizeHeight = hashtagButtons.last??.center.y
        self.hashtagScrollHolder.contentSize = CGSize(width: self.view.frame.width - 100.0, height: contentSizeHeight! + 20.0)
        self.hashtagScrollHolder.contentOffset = CGPointMake(self.hashtagScrollHolder.contentOffset.x, 0)
        
        self.hashtagScrollHolder.delegate = self
        
        loadHashtags()
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.isScrolling = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(decelerate == false){
            self.isScrolling = false
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.isScrolling = false
    }
    
    func makeHashtagunSelected(hashtag:UIButton){
        let daFontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:0.8)
        hashtag.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha:0.3)
        hashtag.setTitleColor(daFontColor, forState: .Normal)
    }
    
    func makeHashtagSelected(hashtag:UIButton){
        hashtag.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
    }
    
    func clearAllHashtags(){
        for i in 0...(self.fakeHashtags.count - 1){
            self.hashtagButtons[i]?.removeFromSuperview()
            
        }
        self.fakeHashtags.removeAll(keepCapacity: false)
        self.hashtagButtons.removeAll(keepCapacity: false)
        self.yPos = 10.0
        
    }
    func createHashtag(title: NSString){
        //let width = Int(title.length)*12
        var title = "#" + (title as String)
        let width = Int(title.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(24.0)]).width) + 10
        var xpos = 0.0
        var widthSpacing = 10.0
        if(hashtagButtons.count > 0){
            let holder = hashtagButtons.last! as UIButton!
            xpos = Double(holder.frame.origin.x) + Double(holder.frame.width) + widthSpacing;
        }
        
        self.widthFiller += width + Int(widthSpacing)
        
        if(Int(self.widthFiller) > Int(self.view.frame.width)){
            self.widthFiller = width + Int(widthSpacing)
            self.yPos += 50.0
            xpos = 0.0
        }
 
        var newButton = UIButton(frame: CGRect(x: Int(xpos), y: Int(yPos), width: width, height: 40))
        newButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        newButton.setTitle(title as String, forState: UIControlState.Normal)
        newButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 24.0)

        self.hashtagScrollHolder.addSubview(newButton)
        self.hashtagButtons.append(newButton)
        newButton.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchDown)
        newButton.addTarget(self, action: "unpressed:", forControlEvents: UIControlEvents.TouchDragExit)
        newButton.addTarget(self, action: "selected:", forControlEvents: UIControlEvents.TouchUpInside)
        
        

    }
    
    func pressed(dabut: UIButton){
        
        if(self.isScrolling == false){
            
                hasStartedClick = false
            let time1 = 0.1
            let startingWidth = dabut.frame.width
            let startingHeight = dabut.frame.height
            let startingX = dabut.frame.origin.x
            let startingY = dabut.frame.origin.y
            let wChanger = CGFloat(5.0)
            let hChanger = CGFloat(10.0)
            let wChanger2 = CGFloat(3.0)
            let hChanger2 = CGFloat(6.0)
            
            UIView.animateWithDuration(time1, delay: 0.0, options: .CurveEaseOut, animations: {
                
                dabut.frame = CGRect(x: startingX - wChanger/2.0, y: startingY - hChanger/2.0, width: startingWidth + wChanger, height: startingHeight + hChanger)
                //dabut.titleLabel!.transform = CGAffineTransformScale(dabut.titleLabel!.transform, 1.1, 1.1);
                //dabut.titleLabel!.center = CGPoint(x: dabut.titleLabel!.center.x + wChanger, y: dabut.titleLabel!.center.y + hChanger);
                
                }, completion: { finished in
                    
                    dabut.titleLabel!.sizeToFit()
            })
            
            }
            
        
    }
    
    func unpressed(dabut: UIButton){
        
        
        
        let time1 = 0.1
        
        
        let wChanger = CGFloat(5.0)
        let hChanger = CGFloat(10.0)
        let wChanger2 = CGFloat(3.0)
        let hChanger2 = CGFloat(6.0)
        let startingWidth = dabut.frame.width - wChanger
        let startingHeight = dabut.frame.height - hChanger
        let startingX = dabut.frame.origin.x + wChanger/2.0
        let startingY = dabut.frame.origin.y + hChanger/2.0
        
        if(self.isScrolling == false){
        hasStartedClick = false
            UIView.animateWithDuration(time1, delay: time1, options: .CurveEaseOut, animations: {
                
                dabut.frame = CGRect(x: startingX + (wChanger + wChanger2)/2.0, y: startingY + (hChanger + hChanger2)/2.0, width: startingWidth - wChanger - wChanger2, height: startingHeight - hChanger - hChanger2)
                
                //dabut.titleLabel!.transform = CGAffineTransformScale(dabut.titleLabel!.transform, 0.91, 0.91);
                //dabut.titleLabel!.center = CGPoint(x: dabut.titleLabel!.center.x - wChanger - wChanger2, y: dabut.titleLabel!.center.y - hChanger - hChanger2);
                
                }, completion: { finished in
                    
                    dabut.titleLabel!.sizeToFit()
            })
            UIView.animateWithDuration(time1, delay: time1*2, options: .CurveEaseOut, animations: {
                
                dabut.frame = CGRect(x: startingX, y: startingY, width: startingWidth, height: startingHeight)
                
                }, completion: { finished in
                    
                    dabut.titleLabel!.sizeToFit()
            })
            
        }
    }
    
    func selected(dabut: UIButton){
        
        let time1 = 0.1
        
       
        let wChanger = CGFloat(5.0)
        let hChanger = CGFloat(10.0)
        let wChanger2 = CGFloat(3.0)
        let hChanger2 = CGFloat(6.0)
        let startingWidth = dabut.frame.width - wChanger
        let startingHeight = dabut.frame.height - hChanger
        let startingX = dabut.frame.origin.x + wChanger/2.0
        let startingY = dabut.frame.origin.y + hChanger/2.0
        if(self.isScrolling == false){
        if(hasStartedClick == false){
            hasStartedClick = true
            
                       
            
            
        
        UIView.animateWithDuration(time1, delay: time1, options: .CurveEaseOut, animations: {
            
            dabut.frame = CGRect(x: startingX + (wChanger + wChanger2)/2.0, y: startingY + (hChanger + hChanger2)/2.0, width: startingWidth - wChanger - wChanger2, height: startingHeight - hChanger - hChanger2)
            
            //dabut.titleLabel!.transform = CGAffineTransformScale(dabut.titleLabel!.transform, 0.91, 0.91);
            //dabut.titleLabel!.center = CGPoint(x: dabut.titleLabel!.center.x - wChanger - wChanger2, y: dabut.titleLabel!.center.y - hChanger - hChanger2);
            
            }, completion: { finished in
               
                dabut.titleLabel!.sizeToFit()
        })
        UIView.animateWithDuration(time1, delay: time1*2, options: .CurveEaseOut, animations: {
                
                dabut.frame = CGRect(x: startingX, y: startingY, width: startingWidth, height: startingHeight)

                }, completion: { finished in
                    
                    dabut.titleLabel!.sizeToFit()
            })
        
        
        hasStartedClick = false
            
            if(self.hasSelectedAHashtag == false){
                for i in 0...(self.hashtagButtons.count - 1){
                    self.makeHashtagunSelected(self.hashtagButtons[i]!)
                }
                self.showNextScreenButton()
            }
            self.makeHashtagSelected(dabut)
            hasSelectedAHashtag = true
            
        }
            
        }
    }
    func centerHashtags(){
        var rowHolder = [UIButton?]()
        var previousY = -1
        for i in 0...(hashtagButtons.count - 1){
            if(i == 0){
                //rowHolder.append(hashtagViews[i])
                let newY = hashtagButtons[i]?.frame.origin.y
                //rowHolder.arrayByAddingObject(hashtagViews[i]!)
                rowHolder.append(hashtagButtons[i]!)
                previousY = Int(newY!)
                
            }
            else{
                let newY = hashtagButtons[i]?.frame.origin.y
                if(previousY == Int(newY!)){
                    //rowHolder.arrayByAddingObject(hashtagViews[i]!)
                    rowHolder.append(hashtagButtons[i]!)
                    
                }
                else{
                    //let vW = self.hashtagScrollHolder.frame.width
                    let vW = self.view.frame.width - 32.0
                    let sX = rowHolder.last?!.frame.origin.x
                    let sW = rowHolder.last?!.frame.width
                    let changeX = (vW - sX! - sW!)/2.0
                    
                    for j in 0...(rowHolder.count - 1){
                        rowHolder[j]!.center = CGPoint(x:rowHolder[j]!.center.x + changeX, y:rowHolder[j]!.center.y)
                        
                    }
                    
                    rowHolder.removeAll(keepCapacity: false)
                    rowHolder.append(hashtagButtons[i]!)
                    let newY = hashtagButtons[i]?.frame.origin.y
                    previousY = Int(newY!)
                    
                    
                }
                
                
            }
            
        }
        
    }
    
    
    func loadHashtags(){
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_hashtags")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        var params = ["gfbid":fbid, "loc":"locatoin"] as Dictionary<String, String>
        
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
                        // self.removeLoadingScreen()
                    
                    self.clearAllHashtags()
                    self.theJSON = json
                    for j in 0...(self.theJSON["results"]!.count - 1){
                        self.fakeHashtags.append(self.theJSON["results"]![j]["body"] as! String)
                    }
                    for i in 0...(self.fakeHashtags.count - 1){
                        self.createHashtag(self.fakeHashtags[i]);
                    }
                        
                        let contentSizeHeight = self.hashtagButtons.last??.center.y
                        self.hashtagScrollHolder.contentSize = CGSize(width: self.view.frame.width - 100.0, height: contentSizeHeight! + 20.0)
                        self.hashtagScrollHolder.setNeedsDisplay()
                        self.hashtagScrollHolder.setNeedsLayout()
                        
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
    
    func showNextScreenButton(){
        var nextButton = UIButton(frame: CGRect(x: 20, y: 20, width: 100, height: 40))
        nextButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        
        nextButton.setTitle("Continue", forState: UIControlState.Normal)
        nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 24.0)
        
        self.view.addSubview(nextButton)
    }
    
    

    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        
    }
     override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
        
}

