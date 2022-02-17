//
//  trailViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 07/02/2022.
//

import UIKit
import MapKit

class trailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, XMLParserDelegate {
    
    @IBOutlet weak var trailMap: MKMapView!
    @IBOutlet weak var trailTable: UITableView!
    
    var trails = getTrailsFromPlist(fileName: "trails")
    var differentTrailTypes = [""]
    var trailCoordinates : [[CLLocationCoordinate2D]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailMap.delegate = self
        trailTable.delegate = self
        trailTable.dataSource = self

        // Do any additional setup after loading the view.
        mapSetUp(mapView: trailMap)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        differentTrailTypes.removeAll()
        for i in trails! {
            if !(differentTrailTypes.contains(i.trailType)) {
                differentTrailTypes.append(i.trailType)
            }
        }
        return differentTrailTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else {
            return 1
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return differentTrailTypes[section]
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if trailMap.overlays.count > 1 {
            removePolyLine(overlay: trailMap.overlays[1], mapView: trailMap)
            trailMap.removeAnnotations(trailMap.annotations)
        }
        if indexPath.section > 0 {
            drawPolyLine(lineName: (trails?[indexPath.row + trailTable.numberOfRows(inSection: 0)].trailName)!, vertices: (trailCoordinates?[indexPath.row + trailTable.numberOfRows(inSection: 0)])!, mapView: trailMap)
        }
        else {
            drawPolyLine(lineName: (trails?[indexPath.row].trailName)!, vertices: (trailCoordinates?[indexPath.row])!, mapView: trailMap)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!!)
            if marker.annotation?.title!! == "Start" {
                marker.markerTintColor = UIColor.systemGreen
            }
            else if marker.annotation?.title!! == "End" {
                marker.markerTintColor = UIColor.systemRed
            }
            return marker
        }
        else {
            return nil
        }
    }

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
    }
    
}
