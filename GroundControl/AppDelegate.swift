//
//  AppDelegate.swift
//  GroundControl
//
//  Created by Francisco Lobo on 11/26/17.
//  Copyright © 2017 Movic Technologies. All rights reserved.
//
// ASFM - Near Space Program - Capsule Ground Control APP.
//
// This APP is used to get data from the NSP Server, See SocketCenter for more details.
//
// --> MAIN FILE DESCRIPTIONS:
// MapViewController.swift = Display individual report locations in a UiMapKit View.
// ReportInfoViewController.swift = Shows the data of the latest report.
//
// Report.swift = Struct [Model] to abstract all report data in an easy to read, write and display object.
// SocketCenter.swift = Singleton class used to encapsulate and centralize all network communications.
//
// TODO : Sort incoming messages by timestamp to prevent sat delays on arrival with both messages.
// TODO : Update timeago clock in realtime to know how old is our last message.


import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let socketCenter = SocketCenter()     //Instantiate the singleton used for network communications.
    
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                
        return true
    }

    func requestOwnShipPermissions() {
        //iOS Devices need user permission for app to access device locations
        var locationManager: CLLocationManager
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

