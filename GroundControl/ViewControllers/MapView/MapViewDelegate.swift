//
//  MapViewDelegate.swift
//  GroundControl
//
//  Created by Francisco Lobo on 2/13/18.
//  Copyright © 2018 Movic Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


// ---------------------------------------------------
// MARK: MKMapViewDelegate Methods (Conforming to the delegate to allow us to show pins in the map)
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if drawingOwnShipPlot == false {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.alpha = 0.3
            polylineRenderer.lineWidth = 2.5
            polylineRenderer.lineDashPattern = [2,5]
        } else {
            polylineRenderer.strokeColor = UIColor.lightGray
            polylineRenderer.alpha = 0.5
            polylineRenderer.lineWidth = 0.5
            drawingOwnShipPlot = false
        }
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateDistanceLabel()
        updatePlotToOwnShip()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        guard let report = getReport(from: annotation) else {
            return nil
        }
        
        let annotationIdentifier = getAnnotationIdentifier(forReport: report)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            let image = UIImage(named: annotationIdentifier)
            annotationView?.image = image
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.collisionMode = .circle
        let transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
        annotationView?.transform = transform
        annotationView?.canShowCallout = true
        
        
        return annotationView
    }
    
    
    func getAnnotationIdentifier(forReport report:Report) -> String {
        var annotationIdentifier = "PinDotBlue"
        
        if report == self.reports.last {
            annotationIdentifier = report.annotationIdentifierForStage()
        } else if report == self.reports.first {
            annotationIdentifier = "PinDotRed"
        } else if report.missionStage == .descent {
            annotationIdentifier = "PinDotOrange"
        }
        
        return annotationIdentifier
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
        UIView.animate(withDuration: 0.2) {
            view.transform = transform
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.2) {
            view.transform = transform
        }
        
        if let annotation = view.annotation {
            
            
            let idx = self.reports.index  { $0.mapAnnotation as MKAnnotation === annotation }
            if let index = idx {
                let report = reports[index]
                
                let formattedDistance = formatDistanceToMetric(from: calculateDistance(from: report.mapAnnotation))
                
                
                var kind = "Telemetry"
                if (report.reportType == .pulse) {
                    kind = "Pulse"
                }
                
                var source = "Cell"
                if (report.originator == .satellite) {
                    source = "Sat"
                }
                
                if (report.originator == .radio) {
                    source = "Rad"
                }
                
                
                let body = """
                Lat: \(report.latitude) - Lon: \(report.longitude)
                Alt: \(report.altitude) ft - Dis: \(formattedDistance)
                Hdg: \(report.course)° - Spd: \(report.speed) kts
                Typ: \(kind) - Ogn: \(source)
                Stg: \(report.missionStage.stringValue())
                """
                
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 0))
                label.numberOfLines = 0
                label.text = body
                view.detailCalloutAccessoryView = label
                label.sizeToFit()
            }
        }
    }
}
