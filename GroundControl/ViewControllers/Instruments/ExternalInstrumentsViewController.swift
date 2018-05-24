//
//  ExternalInstrumentsViewController.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/26/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit

class ExternalInstrumentsViewController: UIViewController, ReportRenderable {
    
    private var latestReport:Report?
    private var initialized = false
    
    @IBOutlet weak var extDTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var extATempLabel: UILabel!
    @IBOutlet weak var atmosPressureLabel: UILabel!
    
    func setReport(_ report: Report) {
        guard report.reportValid == true else { return } //Ignore improperly formatted messages
        self.latestReport = report
        
        if initialized == false { return }
        updateReportView(report: report)
    }
  
    
    func updateReportView(report: Report) {
        self.extDTempLabel.text = "\(report.externalDigitalTemp) °C"
        self.extATempLabel.text = "\(report.externalAnalogTemp) °C"
        self.humidityLabel.text = "\(report.externalDigitalHumidity)%"
        
        if (report.externalDigitalPressure == -1) {
            self.atmosPressureLabel.text = "N/A"
        } else {
            self.atmosPressureLabel.text = "\(report.externalDigitalPressure)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialized = true
        if let latestReport = self.latestReport {
            updateReportView(report: latestReport)
        }
    }

    

    func clearLatestReport() {
        self.extDTempLabel.text = ""
        self.extATempLabel.text = ""
        self.humidityLabel.text = ""
        self.atmosPressureLabel.text = ""
        self.latestReport = nil
    }

}
