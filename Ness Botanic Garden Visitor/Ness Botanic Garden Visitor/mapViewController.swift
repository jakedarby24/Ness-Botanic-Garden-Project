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
        setMapLocation()
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
    func setMapLocation() {
        let latitude = 53.27182
        let longitude = -3.0448
        let latDelta: CLLocationDegrees = 0.0113
        let lonDelta: CLLocationDegrees = 0.0113
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.gardenMapView.setRegion(region, animated: true)
        self.gardenMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
    }
    
    // A function for getting landmark information from the plist files
    func getItemsFromPlist(fileName: String) -> [Landmark]? {
        
        var landmarks: [Landmark]
        
        do {
            // Try to create a URL for the given file path
            guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "plist") else { return nil }
            // Try to get the data that's contained in the file at the file URL
            let fileData = try Data(contentsOf: fileURL)
            // Try to match the format of the plist to an array of landmark objects
            landmarks = try PropertyListDecoder().decode([Landmark].self, from: fileData)
        } catch {
            print("Error")
            return nil
        }
        return landmarks
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
            
            return marker
        }
        else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    }
}
