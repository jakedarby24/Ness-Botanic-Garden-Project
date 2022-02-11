//
//  Landmark.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 29/01/2022.
//

import Foundation
import MapKit

struct Landmark: Codable {
    var enabled: Bool
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var imageLink: String?
    var distanceFromUser: CLLocationDistance?
}
