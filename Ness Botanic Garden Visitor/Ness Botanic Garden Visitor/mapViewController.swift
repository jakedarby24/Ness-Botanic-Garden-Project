//
//  mapViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 22/11/2021.
//

import UIKit
import MapKit

class mapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var gardenMapView: MKMapView!
    var attractions: [Landmark]?
    var sections: [Landmark]?
    var features: [Landmark]?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        gardenMapView.delegate = self

        // Do any additional setup after loading the view.
        mapSetUp()
        addMapAnnotations()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Custom Functions
    // A function that sets the map view to the correct location of the Botanic Garden and zoom level.
    func mapSetUp() {
        let latitude = 53.27182
        let longitude = -3.0448
        let latDelta: CLLocationDegrees = 0.0113
        let lonDelta: CLLocationDegrees = 0.0113
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        drawPolyLine(vertices: nessGardenOutline, mapView: gardenMapView)
        self.gardenMapView.setRegion(region, animated: true)
        self.gardenMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
    }
    
    func addMapAnnotations() {
        features = getItemsFromPlist(fileName: "features")
        for item in features! {
            if item.enabled {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                gardenMapView.addAnnotation(newAnnotation)
            }
        }
        sections = getItemsFromPlist(fileName: "garden_sections")
        for item in sections! {
            if item.enabled {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                gardenMapView.addAnnotation(newAnnotation)
            }
        }
        attractions = getItemsFromPlist(fileName: "attractions")
        for item in attractions! {
            if item.enabled {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                gardenMapView.addAnnotation(newAnnotation)
            }
        }
    }
    
    // MARK: - Delegate Functions
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!!)
            marker.canShowCallout = true
            if annotation.subtitle != "" {
                marker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            for i in features! {
                if annotation.title!! == i.name {
                    marker.markerTintColor = UIColor.purple
                    if annotation.title!! == "Picnic Area" {
                        marker.glyphImage = UIImage(systemName: "fork.knife")
                    }
                    else if annotation.title!! == "View Point" {
                        marker.glyphImage = UIImage(systemName: "binoculars")
                    }
                }
            }
            if marker.markerTintColor != UIColor.purple || marker.markerTintColor != UIColor.green || marker.markerTintColor != UIColor.orange {
                for i in sections! {
                    if annotation.title!! == i.name {
                        marker.markerTintColor = UIColor.systemGreen
                        marker.glyphImage = UIImage(systemName: "mappin.and.ellipse")
                    }
                }
                if marker.markerTintColor != UIColor.purple || marker.markerTintColor != UIColor.green || marker.markerTintColor != UIColor.orange {
                    for i in attractions! {
                        if annotation.title!! == i.name {
                            marker.markerTintColor = UIColor.systemOrange
                            marker.glyphImage = UIImage(systemName: "leaf")
                        }
                    }
                }
            }

            return marker
        }
        else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.purple.withAlphaComponent(0.55)
        polylineRenderer.lineWidth = 3
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    }
}
