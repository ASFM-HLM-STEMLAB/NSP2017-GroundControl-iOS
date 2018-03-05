//
//  InternalInstrumentsViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/26/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

class InternalInstrumentsViewController: UIViewController, ReportRenderable {

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
        self.headingLabel.text = "\(report.course)°"
        self.tempLabel.text = "\(report.internalTempC) °C"
        self.iridiumSatsLabel.text = "\(report.satModemSignal)"
        self.speedLabel.text = "\(report.speed)kts"
        self.distanceLabel.text = "-"
        self.batteryLabel.text = "\(report.batteryLevel)%"
        self.gpsQualityLabel.text = "\(report.horizontalPrecision)"
        self.gpsSatsLabel.text  = "\(report.satellitesInView)"
        self.sonarDistanceLabel.text  = "-"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
