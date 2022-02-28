//
//  Trail.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 15/02/2022.
//

import Foundation

struct Trail: Codable {
    var trailType: String
    var trailName: String
    var description: String
    var accessible: Bool
    var distance: Double
    var latitudes: [Double]
    var longitudes: [Double]
    var images: [String]?
    var pointsOfInterest: [PointOfInterest]?
}

struct PointOfInterest: Codable {
    var trailNumber: Int
    var pointName: String
    var pointDescription: String?
    var pointLatitude: Double
    var pointLongitude: Double
}

