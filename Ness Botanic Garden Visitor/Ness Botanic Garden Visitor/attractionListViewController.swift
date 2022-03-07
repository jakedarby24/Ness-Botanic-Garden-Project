//
//  attractionListViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 01/02/2022.
//

import UIKit
import MapKit

class attractionListViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - Class set-up
    
    // Define class attributes
    var sections: [Landmark]?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // Perform these steps when the view loads
    override func viewDidLoad() {
        // Retrieve the sections of the gardens from local storage
        sections = getPlacesFromPlist(fileName: "garden_sections")
        navigationItem.title = "Places"
        super.viewDidLoad()
        // Start the location manager to get the user's location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Table view data

    // Returns the number of sections for the table (will only ever be 1 for this implementation)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Get the number of rows in the table, i.e. the number of sections of the garden
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections!.count
    }

    // Populate each table cell with the name of the section and the distance it is from the user
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = sections?[indexPath.row].name
        
        // Set the image of the content view to the one specified in local storage
        if sections?[indexPath.row].imageLink != nil {
            content.image = UIImage(named: "images/\(sections?[indexPath.row].imageLink ?? "")")
            content.imageProperties.maximumSize = CGSize(width: 120, height: 96)
        }
        
        // Get the distance of the garden section from the user
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
    
    // MARK: - Location Manager
    
    // Updates the current location, updates the table of locations
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
