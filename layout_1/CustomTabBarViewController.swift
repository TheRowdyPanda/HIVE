//
//  CustomTabBarViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 4/1/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //var myTabBarItem = CustomTabBarViewController.tabBar.items[0] as UITabBarItem
       // myTabBarItem.image = UIImage(named: "PickleTabIcon").imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
       // item.image = UIImage(named: "honey_full.jpg")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
