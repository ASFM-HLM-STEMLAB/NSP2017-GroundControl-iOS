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

// TODO : Test Mission Stage Changing
// TODO : External Sensor Parsing in ExtInstrumentsVC
// TODO : Implement in server sending messages thru satcom
// TODO : Update only relevant data in instrument display
//B= TimeStamp, Lat, Lon, Alt, ExtTemp, ExtHum, ExtPress
//A= TimeStamp, Lat, Lon, Alt, Speed, HDG, GPS_SATS, GPS_PRECISION, BATTLVL, IRIDIUM_SATS, INT_TEMP, STAGE


//COMPUTER.println("-------------------------.--------------------------");
//COMPUTER.println("-------------------------.--------------------------");
//COMPUTER.println("deboff = Debug Off");
//COMPUTER.println("debon = Debug On");
//COMPUTER.println("simon = Start Simulation");
//COMPUTER.println("simoff = Stop Simulation");
//COMPUTER.println("reset = Set mission to ground mode");
//COMPUTER.println("reboot = Reboot Flight Computer");
//COMPUTER.println("simon = Start Simulation");
//COMPUTER.println("cellon = Cell Modem On");
//COMPUTER.println("celloff = Cell Modem Off");
//COMPUTER.println("cellmute = Toggle Cell Reporting");
//COMPUTER.println("satmute = Toggle Sat Reporting");
//COMPUTER.println("saton = SAT Modem ON");
//COMPUTER.println("satoff = SAT Modem Off");
//COMPUTER.println("comoff = All Comunication systems OFF [cell + sat]");
//COMPUTER.println("comon = All Comunication systems ON [cell + sat]");
//COMPUTER.println("gpsdump = GPS Serial Dump to computer toggle");
//COMPUTER.println("satdump = SATCOM Serial Dump to computer toggle");
//COMPUTER.println("querysatsignal = Send a request to the satelite modem to get sat signal");
//COMPUTER.println("querycellsignal = Send a request to the cellular modem to get RSSI signal");
//COMPUTER.println("buzzeron = Turn Buzzer ON");
//COMPUTER.println("buzzeroff = Turn Buzzer ON");
//COMPUTER.println("buzzerchirp = Chirp the buzzer");
//COMPUTER.println("resetinitialaltitude = Set the initial altitude to current altitude");
//COMPUTER.println("preflight? = Go no Go for launch");
//COMPUTER.println("initialaltitude? = Get the initial altitude set uppon gps fix");
//COMPUTER.println("vsi? = Vertical Speed?");
//COMPUTER.println("alt? = Altitude in feet?");
//COMPUTER.println("cell? = Cell Status?");
//COMPUTER.println("cellconnecting? = Cell Modem attempting to connect?");
//COMPUTER.println("cellsignal? = Cell Signal Strength [RSSI,QUAL] ?");
//COMPUTER.println("cloud? = Is cloud available?");
//COMPUTER.println("satsignal? = 0-5 Satcom signal strength?");
//COMPUTER.println("satenabled? = Is the sat modem enabled?");
//COMPUTER.println("bat? = Get battery level?");
//COMPUTER.println("gpsfix? = Get GpsFix ValueType? (0=NoFix,1=Fix,2=DGPSFix)");
//COMPUTER.println("sonar? = Get the sonar distance in meters. (cm for cell)");
//COMPUTER.println("temp? = Get the internal (onboard) temperature in C");
//COMPUTER.println("fwversion? = OS Firmware Version?");
//COMPUTER.println("$ = Print status string");
//COMPUTER.println("$$ = Print and send to CELL cloud status string");
//COMPUTER.println("$$$ = Print and send to SAT cloud status string");
//COMPUTER.println("-------------------------.--------------------------");


import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let socketCenter = SocketCenter()     //Instantiate the singleton used for network communications.
    
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 2.5)
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

