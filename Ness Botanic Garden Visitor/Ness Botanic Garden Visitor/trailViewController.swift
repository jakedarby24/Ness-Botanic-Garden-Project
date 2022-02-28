//
//  trailViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 07/02/2022.
//

import UIKit
import MapKit

class trailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, XMLParserDelegate {
    
    // Outlet declarations
    @IBOutlet weak var trailMap: MKMapView!
    @IBOutlet weak var trailTable: UITableView!
    
    // Class attribute declarations
    var trails = getTrailsFromPlist(fileName: "trails")
    var differentTrailTypes = [""]
    var trailCoordinates : [[CLLocationCoordinate2D]]?
    var treeTrailAnnotations = [MKPointAnnotation]()
    var selectedPinInfo = ("", "")
    
    // The function that runs when the view is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        trailMap.delegate = self
        trailTable.delegate = self
        trailTable.dataSource = self

        // Zoom and position the map correctly
        mapSetUp(mapView: trailMap)
        
        for i in (trails![3].pointsOfInterest!) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: i.pointLatitude, longitude: i.pointLongitude)
            annotation.title = i.pointName
            annotation.subtitle = "\(i.trailNumber)" + " - \(i.pointDescription ?? "")"
            treeTrailAnnotations.append(annotation)
        }
        
        // If the array of trail coordinates has NOT been populated, then load them in
        if trailCoordinates == nil {
            for i in 0..<trails!.count {
                let newTrail = [(CLLocationCoordinate2D(latitude: trails![i].latitudes[0], longitude: trails![i].longitudes[0]))]
                if trailCoordinates == nil {
                    trailCoordinates = [newTrail]
                }
                else {
                    trailCoordinates!.append(newTrail)
                }
                
                for j in 1..<trails![i].latitudes.count {
                    trailCoordinates![i].append(CLLocationCoordinate2D(latitude: trails![i].latitudes[j], longitude: trails![i].longitudes[j]))
                }
            }
        }
        
    }
    
    //MARK: - Delegate Functions
    
    // Gets the number of sections in the table view. Dependent on the different amount of trails
    func numberOfSections(in tableView: UITableView) -> Int {
        differentTrailTypes.removeAll()
        for i in trails! {
            if !(differentTrailTypes.contains(i.trailType)) {
                differentTrailTypes.append(i.trailType)
            }
        }
        return differentTrailTypes.count
    }
    
    // Returns the relevant number of rows in each section
    // As this will stay mostly constant, I have hard coded these in here
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else {
            return 1
        }
    }
    
    // Populate each row in the table view with an appropriate trail
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailCell", for: indexPath)
        cell.accessoryType = .detailButton
        var content = cell.defaultContentConfiguration()
        if indexPath.section == 0 {
            content.text = trails?[indexPath.row].trailName
        }
        else {
            content.text = trails?[indexPath.row + tableView.numberOfRows(inSection: indexPath.section - 1)].trailName
        }
        cell.contentConfiguration = content
        return cell
    }
    
    // Displays the type of trail as the title in the header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return differentTrailTypes[section]
    }
    
    // Polyline renderer function that determines what colour each polyline should be
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        switch overlay.title {
        case trails?[0].trailName:
            polylineRenderer.strokeColor = UIColor.systemGreen
        case trails?[1].trailName:
            polylineRenderer.strokeColor = UIColor.systemBlue
        case trails?[2].trailName:
            polylineRenderer.strokeColor = UIColor.systemOrange
        case trails?[3].trailName:
            polylineRenderer.strokeColor = UIColor.systemRed
        default:
            polylineRenderer.strokeColor = UIColor.purple.withAlphaComponent(0.55)
        }
        
        polylineRenderer.lineWidth = 3
        return polylineRenderer
    }
    
    // Displays the relevant trail on the map when a trail in a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If there is more than one overlay on the map, remove the irrelevant polyline from the map alongside the annotations
        if trailMap.overlays.count > 1 {
            removePolyLine(overlay: trailMap.overlays[1], mapView: trailMap)
            trailMap.removeAnnotations(trailMap.annotations)
        }
        
        // If the tree trail has been selected, display it on the map
        if indexPath.section > 0 {
            drawPolyLine(lineName: (trails?[indexPath.row + trailTable.numberOfRows(inSection: 0)].trailName)!, vertices: (trailCoordinates?[indexPath.row + trailTable.numberOfRows(inSection: 0)])!, mapView: trailMap)
            trailMap.addAnnotations(treeTrailAnnotations)
        }
        // If any other trail is selected, display it on the map
        else {
            drawPolyLine(lineName: (trails?[indexPath.row].trailName)!, vertices: (trailCoordinates?[indexPath.row])!, mapView: trailMap)
            
        }
        
    }
    
    // Determines what each annotation should look like on the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!!)
            if marker.annotation?.title!! == "Start" {
                marker.markerTintColor = UIColor.systemGreen
            }
            else if marker.annotation?.title!! == "End" {
                marker.markerTintColor = UIColor.systemRed
            }
            else {
                marker.markerTintColor = UIColor.init(named: "AccentColor")
                marker.glyphImage = UIImage(systemName: "\(marker.annotation?.subtitle!!.first ?? "0").circle")
                if annotation.subtitle != "" {
                    marker.canShowCallout = true
                    marker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                }
            }
            return marker
        }
        else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedPinInfo.0 = view.annotation?.title! ?? ""
        selectedPinInfo.1 = view.annotation?.subtitle! ?? ""
        performSegue(withIdentifier: "showButtonDetail", sender: nil)
    }

    // Gets the information of the trail that has been selected for showing more information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailDetail" {
            let selectedRow = trailTable.indexPath(for: sender as! UITableViewCell)
            let row = selectedRow!.row + selectedRow!.section * 3
            let secondViewController = segue.destination as! trailDetailController
            secondViewController.trailDesc = trails?[row].description
            secondViewController.trailName = trails?[row].trailName
            secondViewController.trailDist = trails?[row].distance
            secondViewController.accessible = trails?[row].accessible
            secondViewController.trailCoords = trailCoordinates![row]
            secondViewController.imageLinks = trails?[row].images
        }
        else if segue.identifier == "showButtonDetail" {
            let secondViewController = segue.destination as! trailPinDetailController
            secondViewController.pinTitle = selectedPinInfo.0
            selectedPinInfo.1.removeFirst(4)
            secondViewController.pinDescription = selectedPinInfo.1
        }
    }
    
}
