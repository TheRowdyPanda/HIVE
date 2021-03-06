//
//  AppDelegate.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/4/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FBLoginView.self
        FBProfilePictureView.self
        
        
      //  [GAI sharedInstance].trackUncaughtExceptions = YES;
        GAI.sharedInstance().trackUncaughtExceptions = true
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        //[GAI sharedInstance].dispatchInterval = 20;
        GAI.sharedInstance().dispatchInterval = 20
        
        // Optional: set Logger to VERBOSE for debug information.
        //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
        GAI.sharedInstance().logger.logLevel =  GAILogLevel.Verbose;
        
        // Initialize tracker. Replace with your tracking ID.
        //[[GAI sharedInstance] trackerWithTrackingId:@"UA-XXXX-Y"];
        GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        
        //registering for sending user various kinds of notifications

        
        // not for iOS 7
       // let notificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
       // let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
       // application.registerUserNotificationSettings(settings)
        
        let alaume = AMConnect.sharedInstance()
        
        
        // For debugging purposes only
        alaume.isLoggingEnabled = true
        
        alaume.initializeWithAppId("s9", apiKey: "fff5a48b7c7e4999b7a5691d7458eed7")
        
        
        var pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
        pageController.backgroundColor = UIColor.clearColor()
//        pageController.frame = CGRectMake(0, 0, pageController.frame.width, pageController.frame.height)
        
        
          Instabug.startWithToken("882ce2b68fad34d8104d66fbbb42f839", captureSource: IBGCaptureSourceUIKit, invocationEvent: IBGInvocationEventShake)
        
        return true
    }

    //FB Method handles what happens after authentication
//    func application (application:UIApplication, openURL url:NSURL, sourceApplication:NSString?, annotation:AnyObject) -> Bool {
//        //test var
//        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
//        // attempt to extract a token from the url
//        return wasHandled
//        
//    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        
        return wasHandled
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }

    
    // MARK: - Core Data stack
    
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        
        // The directory the application uses to store the Core Data store file. This code uses a directory named "y.Simple_Grade" in the application's documents Application Support directory.
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        return urls[urls.count-1] as! NSURL
        
        }()
    
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        
        let modelURL = NSBundle.mainBundle().URLForResource("Simple_Grade", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        
        }()
    
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        
        // Create the coordinator and store
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Simple_Grade.sqlite")
        
        var error: NSError? = nil
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            
            coordinator = nil
            
            // Report any error we got.
            
            let dict = NSMutableDictionary()
            
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error
            
           // error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            
            abort()
            
        }
        
        
        
        return coordinator
        
        }()
    
    
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        
        let coordinator = self.persistentStoreCoordinator
        
        if coordinator == nil {
            
            return nil
            
        }
        
        var managedObjectContext = NSManagedObjectContext()
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
        
        }()
    
    
    //pragma mark - notifications
//    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if(identifier == "declineAction"){
            
        }
        else if(identifier == "answerAction"){
            
        }
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        NSLog("My device token is: %@", deviceToken)
        
        let dString = NSString(format: "%@", deviceToken)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dString, forKey: "userDeviceToken")
        
        
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Failed to get token %@", error)
        
        let dToke = "none"
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dToke, forKey: "userDeviceToken")
    }
    // MARK: - Core Data Saving support
    
    
    
    func saveContext () {
        
        if let moc = self.managedObjectContext {
            
            var error: NSError? = nil
            
            if moc.hasChanges && !moc.save(&error) {
                
                // Replace this implementation with code to handle the error appropriately.
                
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                
                abort()
                
            }
            
        }
        
    }

}

