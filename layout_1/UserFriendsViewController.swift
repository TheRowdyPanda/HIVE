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
    

    
}
