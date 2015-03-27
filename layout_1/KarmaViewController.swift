//
//  KarmaViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/15/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class KarmaViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet var backScroller: UIScrollView!
    
    @IBOutlet var backImage1: UIImageView!
    @IBOutlet var backImage2: UIImageView!
    @IBOutlet var backImage3: UIImageView!
    
    
    var oldScrollPost:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        backScroller.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //backScroller.contentSize
        
        backScroller.contentSize = CGSize(width:backScroller.frame.width, height:backScroller.frame.height*6)
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
        
        let xPosition = backImage1.frame.origin.x
        
        //View will slide 20px up
       // let yPosition = backImage1.frame.origin.y -(currentOffset)
        
        let yPosition = -0.1*currentOffset
        
        let height = backImage1.frame.size.height
        let width = backImage1.frame.size.width
        
        
        self.oldScrollPost = currentOffset
        UIView.animateWithDuration(0.1, animations: {
            
            self.backImage1.frame = CGRectMake(xPosition, yPosition*3, width, height)
            
            self.backImage2.frame = CGRectMake(xPosition, yPosition*1, width, height)
            
           // self.backImage1.frame = CGRectMake(<#x: CGFloat#>, <#y: CGFloat#>, <#width: CGFloat#>, <#height: CGFloat#>)
            
        })
//        if(currentOffset > 20 && currentOffset < (scrollView.contentSize.height - scrollView.frame.height - 100)){
//        }
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}