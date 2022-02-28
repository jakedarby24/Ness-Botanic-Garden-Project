//
//  SecondScreenController.swift
//  Ness Botanic Garden Visitor WatchKit Extension
//
//  Created by Jake Darby on 17/02/2022.
//

import WatchKit
import Foundation
import MapKit
import CoreLocation

class SecondScreenController: WKInterfaceController, CLLocationManagerDelegate {
    
    @IBOutlet weak var infoTable: WKInterfaceTable!
    
    var places: [Landmark]?
    var trails: [Trail]?
    var displayedTrails: Bool?
    var displayedPlaces: Bool?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let contextResults = context as? (String, String)
        setTitle(contextResults?.1)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if contextResults!.0 == "trails" {
            if trails == nil {
                trails = getTrailsFromPlist(fileName: contextResults!.0)
            }
            infoTable.setNumberOfRows(trails!.count, withRowType: "infoRow")
            for i in 0..<trails!.count {
                let row = infoTable.rowController(at: i) as! menuTableController
                row.titleLabel.setText(trails![i].trailName)
                row.distanceLabel.setHidden(true)
                row.titleLabel.sizeToFitWidth()
            }
            displayedTrails = true
        }
        else {
            if places == nil {
                places = getPlacesFromPlist(fileName: contextResults!.0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: { [self] in
                var newSections: [Landmark]
                newSections = places!
                if places != nil && currentLocation != nil {
                    for i in 0..<newSections.count {
                        places?[i].distanceFromUser = currentLocation?.distance(from: CLLocation(latitude: newSections[i].latitude, longitude: newSections[i].longitude))
                    }
                    places?.sort(by: { $0.distanceFromUser! < $1.distanceFromUser! } )
                }
                infoTable.setNumberOfRows(places!.count, withRowType: "infoRow")
                for i in 0..<places!.count {
                    let row = infoTable.rowController(at: i) as! menuTableController
                    row.titleLabel.setText(places![i].name)
                    row.distanceLabel.setText("\(Int(places![i].distanceFromUser!))m")
                }
                displayedPlaces = true
            })
            
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if displayedPlaces ?? false {
            return places?[rowIndex]
        }
        else {
            return trails?[rowIndex]
        }
        
    }
    
    // MARK: - Location Manager
    
    // Updates the current location, updates the table of locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }

}
