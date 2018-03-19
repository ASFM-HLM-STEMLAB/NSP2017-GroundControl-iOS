//
//  MapViewPlotExtensions.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/13/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// ---------------------------------------------------
// MARK: MAP Plotting Methods and Helpers
extension MapViewController {
    
    func getAllReports() {
        self.reports = [Report]() //Initialize the array with a clean one.
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        
        SocketCenter.getAllReports { (data) in //Ask the SocketCenter singleton to get all past reports.
            if let inReports = data as? [Report] {
                
                let sortedReports = Report.sortReportsByAge(from: inReports)
                for report in sortedReports {
                    self.addReportToMap(report: report)
//                    self.reportDetailViewController?.setReport(report)
//                    self.reportDetailViewController?.setMessageCount(self.reports.count)
                }
            }
            self.focusOnAllReportsOnMap()
            self.updateLastReportTime()
        }
    }
    
    func addReportToMap(report: Report) {
        let lastReport = reports.last
        
        
        if reports.count > 1 {
            mapView.removeAnnotation((lastReport?.mapAnnotation)!)
            mapView.addAnnotation((lastReport?.mapAnnotation)!)
        }
        
        reports.append(report)
        mapView.addAnnotation(report.mapAnnotation)
        
        if reports.count > 1 {
            let firstPoint = lastReport?.mapAnnotation.coordinate
            let secondPoint = reports.last?.mapAnnotation.coordinate
            drawOverlayLine(from: firstPoint!, to: secondPoint!)
            updatePlotToOwnShip()
        }
        
        updateLastReportTime()
        addReportToDashboard(report: report)
    }
    
    func addReportToDashboard(report: Report) {
        self.dashboardViewController?.setMessageCount(reports.count)
        self.dashboardViewController?.setReport(report)
        self.instrumentsPageController?.setMessageCount(reports.count)
        self.instrumentsPageController?.setReport(report)
    }
    
    
    func drawOverlayLine(from startLoc:CLLocationCoordinate2D, to endLoc:CLLocationCoordinate2D) {
        if (endLoc.longitude == 0.0 || endLoc.latitude == 0.0) { return }
        if (startLoc.longitude == 0.0 || startLoc.latitude == 0.0) { return }
        
        let coords = [startLoc, endLoc]
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        self.mapView.add(polyline, level: .aboveRoads)
    }
    
    func updatePlotToOwnShip() {
           drawingOwnShipPlot = false
        if (self.reports.count >= 1) {
            drawingOwnShipPlot = true
            if let ownShipLine = self.ownshipLine {
                mapView.remove(ownShipLine)
            }
            
            let coordinates = [self.reports.last!.coordinate, mapView.userLocation.coordinate]
            ownshipLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.add(ownshipLine!, level: .aboveRoads)
        }
    }
    
    func focusOnAllReportsOnMap() {
        let annotations = reports.flatMap { (report) -> MapAnnotation? in
            if (report.coordinate.latitude == 0 || report.coordinate.longitude == 0) {
                return nil
            }
            
            return report.mapAnnotation
        }
        
        self.mapView.showAnnotations(annotations, animated: true)
    }

    func getReport(from annotation: MKAnnotation) -> Report? {
        let idx = self.reports.index  { $0.mapAnnotation as MKAnnotation === annotation }
        if let index = idx {
            let report = reports[index]
            return report
        }
        
        return nil
    }
    
    func withoutDuplicates(from reports:[Report]) -> [Report] {
        var newReports = [Report]()
        
        for report in self.reports {
            if !newReports.contains(report) {
                newReports.append(report)
            }
        }
        
        return newReports
    }
    
}
