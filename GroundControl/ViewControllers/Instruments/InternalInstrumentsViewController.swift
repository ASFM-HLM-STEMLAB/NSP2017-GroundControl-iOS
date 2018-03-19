//
//  InternalInstrumentsViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/26/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

//TIME,LAT,LON,ALT,SPEED,COURSE,SATS,HDOP,BATT,SAT,STAGE
//A= TimeStamp, Lat, Lon, Alt, Speed, HDG, GPS_SATS, GPS_PRECISION, BATTLVL, IRIDIUM_SATS, INT_TEMP, STAGE
//B= TimeStamp, Lat, Lon, Alt, ExtTemp, ExtHum, ExtPress

class InternalInstrumentsViewController: UIViewController, ReportRenderable {

    @IBOutlet weak var dataBeaconView: UIView!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iridiumSatsLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var gpsQualityLabel: UILabel!
    @IBOutlet weak var gpsSatsLabel: UILabel!
    @IBOutlet weak var sonarDistanceLabel: UILabel!
    
    func setReport(_ report: Report) {                
        self.altitudeLabel.text = "\(report.altitude)ft"
        
        guard report.reportType == .pulse else { return } //We only update on A message (PULSE)
        
        dataBeaconView.alpha = 1.0;
        headingLabel.text = "\(report.course)°"
        tempLabel.text = "\(report.internalTempC) °C"
        iridiumSatsLabel.text = "\(report.satModemSignal)"
        speedLabel.text = "\(report.speed)kts"
        distanceLabel.text = "-"
        batteryLabel.text = "\(report.batteryLevel)%"
        gpsQualityLabel.text = "\(report.horizontalPrecision)"
        gpsSatsLabel.text  = "\(report.satellitesInView)"
        sonarDistanceLabel.text  = "-"
        
        self.view.layer .removeAllAnimations()
        UIView.animate(withDuration: 50) {
            self.dataBeaconView.alpha = 0.0
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBeaconView.layer.cornerRadius = dataBeaconView.bounds.size.width / 2
        dataBeaconView.layer.shadowColor = UIColor.green.cgColor
        dataBeaconView.layer.shadowOffset = CGSize.zero
        dataBeaconView.layer.shadowRadius = 5
        dataBeaconView.layer.shadowOpacity = 1.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
