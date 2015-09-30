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
        
        self.tabBar.tintColor = UIColor.blackColor()
       // self.tabBar.layer.borderColor = UIColor.blackColor().CGColor
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 1.0))
        topBorder.backgroundColor = UIColor(red: (85.0/255.0), green: (85.0/255.0), blue: (85.0/255.0), alpha: 1.0)
        self.tabBar.addSubview(topBorder)
     //   self.tabBar.layer.borderWidth = 20
        self.tabBar.selectedImageTintColor = UIColor(red: (255.0/255.0), green: (210.0/255.0), blue: (11.0/255.0), alpha: 1.0)
      //  self.tabBar.selectedImageTintColor = UIColor.whiteColor()
        

//        //feed item
//        var tb1 = self.tabBar.items![0] as! UITabBarItem
//        let im1a = UIImage(named: "Feed.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let im1b = imageWithImage(im1a!, scaledToSize: CGSizeMake(self.view.frame.width/12, self.view.frame.width/12))
//        tb1.image = im1b
//        let im1c = UIImage(named: "Feed.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let im1d = imageWithImage(im1c!, scaledToSize: CGSizeMake(self.view.frame.width/12, self.view.frame.width/12))
//        tb1.selectedImage = im1d
//        
//        
//        //profile item
//        var tb2 = self.tabBar.items![1] as! UITabBarItem
//        let im2a = UIImage(named: "Me.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let im2b = imageWithImage(im1a!, scaledToSize: CGSizeMake(self.view.frame.width/12, self.view.frame.width/12))
//        tb2.image = im2b
//        let im2c = UIImage(named: "Me.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let im2d = imageWithImage(im1c!, scaledToSize: CGSizeMake(self.view.frame.width/12, self.view.frame.width/12))
//        tb2.selectedImage = im2d
//        
//        
//        //notifications item
//        var tb3 = self.tabBar.items![2] as! UITabBarItem
//        let im3a = UIImage(named: "Me.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let im3b = imageWithImage(im1a!, scaledToSize: CGSizeMake(self.view.frame.width/12, self.view.frame.width/12))
//        tb3.image = im3b
//        let im3c = UIImage(named: "Me.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let im3d = imageWithImage(im1c!, scaledToSize: CGSizeMake(self.view.frame.width/12, self.view.frame.width/12))
//        tb3.selectedImage = im3d
//        
//        //following item
//        var tb4 = self.tabBar.items![3] as! UITabBarItem
//        let im4a = UIImage(named: "Me.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let im4b = imageWithImage(im1a!, scaledToSize: CGSizeMake(self.view.frame.width/12, self.view.frame.width/12))
//        tb4.image = im4b
//        let im4c = UIImage(named: "Me.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let im4d = imageWithImage(im1c!, scaledToSize: CGSizeMake(self.view.frame.width/12, self.view.frame.width/12))
//        tb4.selectedImage = im4d
//
        
        
        //var myTabBarItem = CustomTabBarViewController.tabBar.items[0] as UITabBarItem
       // myTabBarItem.image = UIImage(named: "PickleTabIcon").imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
