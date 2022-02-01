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
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setMapLocation()
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
        }
        return landmarks
    }
}
