//
//  UsefulFunctions.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 03/02/2022.
//

import Foundation
import MapKit

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

// Draws an overlay on a MapKit map
func drawPolyLine(vertices: [CLLocationCoordinate2D], mapView: MKMapView) {
    let polyLine = MKPolyline(coordinates: vertices, count: vertices.count)
    mapView.addOverlay(polyLine)
}

// Sets the glyph image and colour of an annotation view on the map
func setAnnotationStyle(marker: MKMarkerAnnotationView, annotation: MKAnnotation, features: [Landmark]?, attractions: [Landmark]?, sections: [Landmark]?) -> MKMarkerAnnotationView {
    for i in features! {
        switch annotation.title!! {
        case "Picnic Area":
            marker.markerTintColor = UIColor.purple
            marker.glyphImage = UIImage(systemName: "fork.knife")
            return marker
        case "View Point":
            marker.markerTintColor = UIColor.purple
            marker.glyphImage = UIImage(systemName: "binoculars")
            return marker
        case i.name:
            marker.markerTintColor = UIColor.purple
            return marker
        default:
            print("Next List")
        }
    }
    for i in attractions! {
        switch annotation.title!! {
        case i.name:
            marker.markerTintColor = UIColor.systemOrange
            marker.glyphImage = UIImage(systemName: "leaf")
            return marker
        default:
            print("Next List")
        }
    }
    for i in sections! {
        switch annotation.title!! {
        case i.name:
            marker.markerTintColor = UIColor.systemGreen
            marker.glyphImage = UIImage(systemName: "mappin.and.ellipse")
            return marker
        default:
            print("Next i")
        }
    }
    
    return marker
}
