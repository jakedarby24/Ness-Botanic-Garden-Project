//
//  mapViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 22/11/2021.
//

import UIKit
import MapKit

class mapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Storyboard Outlets/Actions
    @IBOutlet var gardenMapView: MKMapView!
    @IBOutlet weak var tableParentView: UIView!
    @IBOutlet weak var searchResultTable: UITableView!
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
    
    @IBAction func filterTapped(_ sender: Any) {
        addMapAnnotations()
    }

    @IBAction func locationHeadingButton(_ sender: UIButton) {
        if toggleStateHeading {
            locationManager.stopUpdatingHeading()
            gardenMapView.userTrackingMode = .none
            toggleStateHeading = false
            gardenMapView.isUserInteractionEnabled = true
            sender.setImage(UIImage(systemName: "location.fill"), for: .normal)
        }
        else {
            locationManager.startUpdatingHeading()
            gardenMapView.userTrackingMode = .followWithHeading
            toggleStateHeading = true
            gardenMapView.isUserInteractionEnabled = false
            sender.setImage(UIImage(systemName: "location.north.line.fill"), for: .normal)
        }
    }
    
    
    
    // MARK: - Class Attributes
    var filteredData: [Landmark]?
    
    var attractions: [Landmark]?
    var sections: [Landmark]?
    var features: [Landmark]?
    var allLandmarks: [Landmark]?
    
    var selectedTitle: String?
    var selectedDescription: String?
    var selectedCoordinates: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var searchBar = UISearchBar()
    var headingImageView: UIImageView?
    var toggleStateHeading = false
    
    //MARK: - View Loaded
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        gardenMapView.delegate = self
        locationManager.delegate = self
        searchBar.delegate = self
        searchResultTable.delegate = self
        searchResultTable.dataSource = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
        mapSetUp(mapView: gardenMapView)
        addMapAnnotations()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for a feature"
        searchBar.setShowsCancelButton(true, animated: true)
        navigationItem.titleView = searchBar
        searchResultTable.isHidden = true
        searchBar.showsCancelButton = false
        tableParentView.isHidden = true
        
    }

    // MARK: - Storyboard navigation

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
    
    // Get all of the features from all three plist files and create map annotations for them
    func addMapAnnotations() {
        gardenMapView.removeAnnotations(gardenMapView.annotations)
        features = getPlacesFromPlist(fileName: "features")
        sections = getPlacesFromPlist(fileName: "garden_sections")
        attractions = getPlacesFromPlist(fileName: "attractions")
        switch filterSegmentControl.selectedSegmentIndex {
        case 0:
            for item in features! {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                gardenMapView.addAnnotation(newAnnotation)
            }
            for item in sections! {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                gardenMapView.addAnnotation(newAnnotation)
            }
            for item in attractions! {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                gardenMapView.addAnnotation(newAnnotation)
            }
        case 1:
            for item in sections! {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                gardenMapView.addAnnotation(newAnnotation)
            }
        case 2:
            for item in attractions! {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                gardenMapView.addAnnotation(newAnnotation)
            }
        case 3:
            for item in features! {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                newAnnotation.title = item.name
                newAnnotation.subtitle = item.description
                gardenMapView.addAnnotation(newAnnotation)
            }
        default:
            print("Error")
        }
        // Create an array that contains all of the landmarks, for use with the search function
        allLandmarks = features! + sections! + attractions!
    }
    
    // MARK: - Map Delegate Functions
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!!)
            marker.displayPriority = MKFeatureDisplayPriority.required
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

    // MARK: - Search Delegate Functions
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultTable.isHidden = true
        tableParentView.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = allLandmarks?.filter({ i in
            i.name.localizedCaseInsensitiveContains(searchText)
        })
        searchResultTable.isHidden = false
        tableParentView.isHidden = false
        tableParentView.sizeToFit()
        tableParentView.sizeThatFits(searchResultTable.intrinsicContentSize)
        self.searchResultTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Make the view visible
        searchBar.showsCancelButton = true
        self.view.bringSubviewToFront(tableParentView)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Make the view invisible
        searchBar.showsCancelButton = false
        self.view.sendSubviewToBack(tableParentView)
    }
    
    // MARK: - Search Table Delegate Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData?.count == 0 {
            return 1
        }
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        var content = cell?.defaultContentConfiguration()
        // If there are no matching search results
        if filteredData?.count == 0 {
            content?.text = "No results"
            content?.textProperties.font = UIFont.italicSystemFont(ofSize: 14)
            content?.textProperties.color = UIColor.systemGray2
            cell?.isUserInteractionEnabled = false
        }
        // If there ARE matching search results
        else {
            content?.text = filteredData?[indexPath.row].name
            content?.textProperties.font = UIFont.systemFont(ofSize: 16)
            content?.textProperties.color = UIColor.label
            cell?.isUserInteractionEnabled = true
        }
        cell?.contentConfiguration = content
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // On selecting a row, identify the landmark on the map and manually select it
        filterSegmentControl.selectedSegmentIndex = 0
        addMapAnnotations()
        gardenMapView.showAnnotations(gardenMapView.annotations.filter({ annotation in
            if annotation.title == filteredData?[indexPath.row].name {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.gardenMapView.selectAnnotation(annotation, animated: true)
                }
            }
            return annotation.title == filteredData?[indexPath.row].name
        }), animated: true)
        // Hide the table, dismiss the keyboard
        searchResultTable.isHidden = true
        tableParentView.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
