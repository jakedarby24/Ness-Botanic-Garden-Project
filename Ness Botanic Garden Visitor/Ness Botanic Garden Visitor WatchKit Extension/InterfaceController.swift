//
//  InterfaceController.swift
//  Ness Botanic Garden Visitor WatchKit Extension
//
//  Created by Jake Darby on 22/11/2021.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var menuTable: WKInterfaceTable!
    
    let tableTitles = ["Trails", "Places", "Flora"]
    let tableRelations = ["trails", "garden_sections", "attractions"]
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        menuTable.setNumberOfRows(tableTitles.count, withRowType: "menuTable")
        for i in 0..<tableTitles.count {
            let row = menuTable.rowController(at: i) as! menuTableController
            row.titleLabel.setText(tableTitles[i])
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return (tableRelations[rowIndex], tableTitles[rowIndex])
    }

}
