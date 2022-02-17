//
//  floraListViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 03/02/2022.
//

import UIKit
import MapKit

class floraListViewController: UITableViewController, CLLocationManagerDelegate {

    var flowers: [Landmark]?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        flowers = getPlacesFromPlist(fileName: "attractions")
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
        return flowers!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "floraCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = flowers?[indexPath.row].name
        if flowers?[indexPath.row].imageLink != nil {
            content.image = UIImage(named: "images/\(flowers?[indexPath.row].imageLink ?? "")")
            content.imageProperties.maximumSize = CGSize(width: 120, height: 96)
        }
        if flowers?[indexPath.row].distanceFromUser != nil {
            content.secondaryText = "\(Int(flowers![indexPath.row].distanceFromUser!))m away"
        }
        cell.contentConfiguration = content
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetailFromFlora" {
            let selectedRow = tableView.indexPath(for: sender as! UITableViewCell)
            let secondViewController = segue.destination as! placeDetailViewController
            secondViewController.titleName = flowers![selectedRow!.row].name
            secondViewController.descriptionName = flowers![selectedRow!.row].description
            secondViewController.position = CLLocationCoordinate2D(latitude: flowers![selectedRow!.row].latitude, longitude: flowers![selectedRow!.row].longitude)
        }
    }
    
    //updates the current location, updates the table of locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        var newFlowers: [Landmark]
        newFlowers = flowers!
        if flowers != nil && currentLocation != nil {
            for i in 0..<newFlowers.count {
                flowers?[i].distanceFromUser = currentLocation?.distance(from: CLLocation(latitude: newFlowers[i].latitude, longitude: newFlowers[i].longitude))
            }
            flowers?.sort(by: { $0.distanceFromUser! < $1.distanceFromUser! } )
            self.tableView.reloadData()
        }
    }

}
