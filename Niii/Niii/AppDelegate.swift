//
//  AppDelegate.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        initAppearance()
        
        return true
    }

    func initAppearance() -> Void {
        // Initialize Launch Screen
        let background = CAGradientLayer().blueColor()
        let objects = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: self, options: nil)
        background.frame = objects[0].bounds
        objects[0].layer.insertSublayer(background, atIndex: 0)
        
        // Set the color of all navigation bars to blue
        var navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColorFromHex.color(0x6698FF)
        let navigationTitleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBarAppearance.titleTextAttributes = navigationTitleDict as [NSObject : AnyObject]
        
        // Set the selected color of the selected cell
        let colorView = UIView()
        colorView.backgroundColor = UIColor(red: 130/255.0, green: 185/255.0, blue: 255/255.0, alpha: 0.5)
        UITableViewCell.appearance().selectedBackgroundView = colorView
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

