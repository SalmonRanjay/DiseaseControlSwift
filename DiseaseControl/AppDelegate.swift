//
//  AppDelegate.swift
//  DiseaseControl
//
//  Created by ranjay on 9/26/15.
//  Copyright (c) 2015 ranjay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Gimbal.setAPIKey("def4d3a0-61f9-4664-8ba9-36bcc16da238", options: nil)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil));
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if(!GMBLPlaceManager.isMonitoring()){
            GMBLPlaceManager.startMonitoring();
        }
        GMBLCommunicationManager.startReceivingCommunications();
       
    }
    
    
    
    func communicationManager(manager: GMBLCommunicationManager!, presentLocalNotificationsForCommunications communications: [AnyObject]!, forVisit visit: GMBLVisit!) -> [AnyObject]! {
        if(communications is [GMBLCommunication]){
            for comm in communications{
                
                println("comm Title: \(comm.title), description: \(comm.descriptionText)");
                
                var localNotification: UILocalNotification = UILocalNotification()
                localNotification.alertAction = "Testing notifications on iOS8"
                localNotification.alertBody = "\(comm.title)"
                localNotification.fireDate = NSDate(timeIntervalSinceNow: 30)
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

                
                /*
                let alert = UIAlertController(title: "Warning", message: "Entering \(visit.place.name)", preferredStyle: UIAlertControllerStyle.Alert);
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil)
                */
                
                println("RECEIEVED AN UPDATE EVENT IN THE APP DELEGATE");
                
            }
            
            
        }
        return communications
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
    }


}

