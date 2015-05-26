//
//  LocationPeakViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 5/25/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit
import MapKit


class LocationPeakViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var titleItem:UINavigationItem!
    var locationName = "..."
    var latLon = "none"
    var locLat = "none"
    var locLon = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.zoomEnabled = false
        self.mapView.scrollEnabled = false
        self.mapView.userInteractionEnabled = false
        
        
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
        

        
    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    

    
    
    
    override func viewDidAppear(animated: Bool) {

    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}