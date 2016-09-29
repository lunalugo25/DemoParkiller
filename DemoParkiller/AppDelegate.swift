//
//  AppDelegate.swift
//  DemoParkiller
//
//  Created by jorge luna on 24/09/16.
//  Copyright © 2016 Jorge Luna. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(application: UIApplication) {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyDQR4yU0hrqw4sHMCs1THRXdvg_JbjGnZ0")
        //AIzaSyD5g_1jw-iA9DSf0N6WtwYUWStYPwKduFU
        //AIzaSyBsk3BdmNkwXUo7Z-1kqGrkK3bwVG2or2Q
        //AIzaSyBWDAfR_Q8SdFk7V0IRc7rqjAulpb0z-2g
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let navController = story.instantiateViewControllerWithIdentifier("navigationMain") as! UINavigationController
            
            window.backgroundColor = UIColor.whiteColor()
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

