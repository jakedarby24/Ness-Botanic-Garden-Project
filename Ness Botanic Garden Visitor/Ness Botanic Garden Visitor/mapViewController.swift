//
//  mapViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 22/11/2021.
//

import UIKit
import MapKit

class mapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var gardenMapView: MKMapView!
    var attractions: [Landmark]?
    var sections: [Landmark]?
    var features: [Landmark]?
    
    var selectedTitle: String?
    var selectedDescription: String?
    var selectedCoordinates: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        gardenMapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
        mapSetUp(mapView: gardenMapView)
        addMapAnnotations()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetailViewSegue" {
            let secondViewController = segue.destination as! placeDetailViewController
            secondViewController.titleName = selectedTitle
            secondViewController.descriptionName = selectedDescription
            secondViewController.position = selectedCoordinates
        }
    }
    
    
    // MARK: - Custom Functions
    // A function that sets the map view to the correct location of the Botanic Garden and zoom level.
    
    func addMapAnnotations() {
        features = getPlacesFromPlist(fileName: "features")
        for item in features! {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            newAnnotation.title = item.name
            newAnnotation.subtitle = item.description
            gardenMapView.addAnnotation(newAnnotation)
        }
        sections = getPlacesFromPlist(fileName: "garden_sections")
        for item in sections! {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            newAnnotation.title = item.name
            newAnnotation.subtitle = item.description
            gardenMapView.addAnnotation(newAnnotation)
        }
        attractions = getPlacesFromPlist(fileName: "attractions")
        for item in attractions! {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.title = item.name
            newAnnotation.subtitle = item.description
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            gardenMapView.addAnnotation(newAnnotation)
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
            
            return setAnnotationStyle(marker: marker, annotation: annotation, features: features, attractions: attractions, sections: sections)
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
        selectedTitle = view.annotation?.title!!
        selectedDescription = view.annotation?.subtitle!!
        selectedCoordinates = view.annotation?.coordinate
        performSegue(withIdentifier: "placeDetailViewSegue", sender: nil)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let coordinate = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        var span = mapView.region.span
        if span.latitudeDelta < 0.003 { // MIN LEVEL
            span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        } else if span.latitudeDelta > 0.01 { // MAX LEVEL
            span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
    }
}
