//
//  UserFriendsViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/15/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit



class UserFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userFBID = "none"
    var ajaxRequestString = "none"
    
   @IBOutlet var tableView:UITableView!
    @IBOutlet var titleItem:UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = tableView.frame.height/8
        
        if(ajaxRequestString == "followers"){
            titleItem.title = "Followers"
        }
        else if(ajaxRequestString == "following"){
            titleItem.title = "Following"
        }
        
        get_user_followers()
    }
    
    override func viewDidAppear(animated: Bool) {
        println(ajaxRequestString)
        println(userFBID)
        
    
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    //pragma mark - table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //make sure the json has loaded before we do anything
        return 5
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("user_cell") as user_cell
        
    

        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
     
        
    }
    
    
    
    //pragma mark - ajax
    func get_user_followers(){
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_user_followers")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["gUser_fbID":fbid, "iUser_fbID":userFBID] as Dictionary<String, String>
        
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
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{

                    })
                    
                    
                    
                }
                else {
                    
                    
                }
            }
        })
        task.resume()
        //END AJAX

        
    }

    
}
