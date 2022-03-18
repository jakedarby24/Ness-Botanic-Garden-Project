//
//  UsefulFunctions.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 03/02/2022.
//
//  A file that contains some useful functions for use around the program

import Foundation

// MARK: - Get places from Plist
func getPlacesFromPlist(fileName: String) -> [Landmark]? {
    
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
    return landmarks.filter { i in
        i.enabled
    }
}

// MARK: - Get trails from Plist
func getTrailsFromPlist(fileName: String) -> [Trail]? {
    
    var trails: [Trail]
    
    do {
        // Try to create a URL for the given file path
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "plist") else { return nil }
        // Try to get the data that's contained in the file at the file URL
        let fileData = try Data(contentsOf: fileURL)
        // Try to match the format of the plist to an array of landmark objects
        trails = try PropertyListDecoder().decode([Trail].self, from: fileData)
    } catch {
        print("Error")
        return nil
    }
    return trails
}
