//
//  UserPostsViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/15/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class UserPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
     @IBOutlet var tableView:UITableView!
    
    var userFBID = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
      
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
        var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell") as custom_cell
        
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }

}