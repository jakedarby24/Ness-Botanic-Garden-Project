//
//  attractionListViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 01/02/2022.
//

import UIKit
import MapKit

class attractionListViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var sections: [Landmark]?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        sections = getItemsFromPlist(fileName: "garden_sections")
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = sections?[indexPath.row].name
        if sections?[indexPath.row].imageLink != nil {
            content.image = UIImage(named: "images/\(sections?[indexPath.row].imageLink ?? "")")
            content.imageProperties.maximumSize = CGSize(width: 120, height: 96)
        }
        if sections?[indexPath.row].distanceFromUser != nil {
            content.secondaryText = "\(Int(sections![indexPath.row].distanceFromUser!))m away"
        }
        cell.contentConfiguration = content
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetailFromTable" {
            let selectedRow = tableView.indexPath(for: sender as! UITableViewCell)
            let secondViewController = segue.destination as! placeDetailViewController
            secondViewController.titleName = sections![selectedRow!.row].name
            secondViewController.descriptionName = sections![selectedRow!.row].description
            secondViewController.position = CLLocationCoordinate2D(latitude: sections![selectedRow!.row].latitude, longitude: sections![selectedRow!.row].longitude)
        }
    }
    
    //updates the current location, updates the table of locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        var newSections: [Landmark]
        newSections = sections!
        if sections != nil && currentLocation != nil {
            for i in 0..<newSections.count {
                sections?[i].distanceFromUser = currentLocation?.distance(from: CLLocation(latitude: newSections[i].latitude, longitude: newSections[i].longitude))
            }
            sections?.sort(by: { $0.distanceFromUser! < $1.distanceFromUser! } )
            self.tableView.reloadData()
        }
    }

}
