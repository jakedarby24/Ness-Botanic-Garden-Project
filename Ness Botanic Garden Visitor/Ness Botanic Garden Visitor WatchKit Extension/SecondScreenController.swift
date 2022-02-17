//
//  SecondScreenController.swift
//  Ness Botanic Garden Visitor WatchKit Extension
//
//  Created by Jake Darby on 17/02/2022.
//

import WatchKit
import Foundation
import MapKit

class SecondScreenController: WKInterfaceController {
    
    @IBOutlet weak var infoTable: WKInterfaceTable!
    
    var places: [Landmark]?
    var trails: [Trail]?
    var displayedTrails: Bool?
    var displayedPlaces: Bool?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let contextResults = context as? (String, String)
        setTitle(contextResults?.1)
        
        if contextResults!.0 == "trails" {
            trails = getTrailsFromPlist(fileName: contextResults!.0)
            infoTable.setNumberOfRows(trails!.count, withRowType: "infoRow")
            for i in 0..<trails!.count {
                let row = infoTable.rowController(at: i) as! menuTableController
                row.titleLabel.setText(trails![i].trailName)
            }
            displayedTrails = true
        }
        else {
            places = getPlacesFromPlist(fileName: contextResults!.0)
            infoTable.setNumberOfRows(places!.count, withRowType: "infoRow")
            for i in 0..<places!.count {
                let row = infoTable.rowController(at: i) as! menuTableController
                row.titleLabel.setText(places![i].name)
            }
            displayedPlaces = true
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

}
