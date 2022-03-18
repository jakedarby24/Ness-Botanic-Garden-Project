//
//  placeDetailViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 04/02/2022.
//

import UIKit
import MapKit

class placeDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //MARK: - Outlets and Actions
    
    // Outlets from the storyboard
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var positionOfLandmarkMap: MKMapView!
    @IBOutlet weak var timeDistanceLabel: UILabel!
    @IBOutlet weak var notificationOnlyImageView: UIImageView!
    @IBOutlet weak var walkingDirectionsInfoLabel: UILabel!
    
    // Action function for when the map is tapped.
    // This redirects the user to Apple Maps, if installed.
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        let directionsURL = "http://maps.apple.com/?saddr=\(currentLocation!.coordinate.latitude),\(currentLocation!.coordinate.longitude)&daddr=\(position!.latitude),\(position!.longitude)&dirflg=w&t=m"
        guard let url = URL(string: directionsURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK: - Attributes
    
    // Class attributes
    var titleName: String?
    var descriptionName: String?
    var position: CLLocationCoordinate2D?
    var imageLink: String?
    
    var attractions: [Landmark]?
    var sections: [Landmark]?
    var features: [Landmark]?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // MARK: - View Setup
    
    // Runs when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        positionOfLandmarkMap.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        attractions = getPlacesFromPlist(fileName: "attractions")
        features = getPlacesFromPlist(fileName: "features")
        sections = getPlacesFromPlist(fileName: "garden_sections")
        
        /* If the image is nil, it signifies to the controller that the page has been
           accessed from the table view and not a notification. The map should be shown,
           and not an image.
           If the image contains a value, it signifies that this is a redirect from a
           notification and so the map should be hidden and an image shown instead, as
           the user will not need directions to the landmark.
         */
        if imageLink == nil {
            notificationOnlyImageView.isHidden = true
        }
        else {
            positionOfLandmarkMap.isHidden = true
            self.view.bringSubviewToFront(notificationOnlyImageView)
            notificationOnlyImageView.image = UIImage(named: "images/\(imageLink!)")
            timeDistanceLabel.isHidden = true
            walkingDirectionsInfoLabel.isHidden = true
        }
        
        titleLabel.text = titleName
        descriptionLabel.text = descriptionName
        descriptionLabel.sizeToFit()
        let latDelta: CLLocationDegrees = 0.003
        let lonDelta: CLLocationDegrees = 0.003
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region = MKCoordinateRegion(center: position!, span: span)
        self.positionOfLandmarkMap.setRegion(region, animated: true)
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: position!.latitude, longitude: position!.longitude)
        newAnnotation.title = titleName
        positionOfLandmarkMap.addAnnotation(newAnnotation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.currentLocation != nil {
                self.showRouteOnMap(startCoord: self.currentLocation!.coordinate, endCoord: newAnnotation.coordinate)
            }
            else {
                let alert = UIAlertController(title: "Location Disabled", message: "Enable location to see directions to this landmark", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: {_ in
                    settingsRedirect()
                }))
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - Map Delegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!!)
            return setAnnotationStyle(marker: marker, annotation: annotation, features: features, attractions: attractions, sections: sections)
        }
        else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.systemCyan
        polylineRenderer.lineWidth = 3
        return polylineRenderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    // MARK: - Table Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Custom Methods
    
    func showRouteOnMap(startCoord: CLLocationCoordinate2D, endCoord: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoord, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endCoord, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking

        let directions = MKDirections(request: request)
        
        self.view.isUserInteractionEnabled = false

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else {
                let noConnectionAlert = UIAlertController(title: "No network connection", message: "Please connect to a Wi-Fi network or mobile data to display directions between you and this place", preferredStyle: UIAlertController.Style.alert)
                noConnectionAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(noConnectionAlert, animated: true, completion: nil)
                return
            }
            
            if let route = unwrappedResponse.routes.first {
                //show on map
                self.positionOfLandmarkMap.addOverlay(route.polyline)
                //set the map area to show the route
                self.positionOfLandmarkMap.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 60.0, left: 20.0, bottom: 80.0, right: 20.0), animated: true)
                if route.expectedTravelTime > 3600 {
                    self.timeDistanceLabel.text = "\(Int(route.distance / 1000.0))km along paths, ~\(Int(route.expectedTravelTime / 3600.0)) hrs"
                }
                else {
                    self.timeDistanceLabel.text = "\(Int(route.distance))m along paths, \(Int(route.expectedTravelTime / 60.0)) mins"
                }
            }
        }
        self.view.isUserInteractionEnabled = true
    }
}

func settingsRedirect() {
    if let bundleId = Bundle.main.bundleIdentifier,
        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
    {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
