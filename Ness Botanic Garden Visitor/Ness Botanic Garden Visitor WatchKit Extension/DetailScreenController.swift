//
//  DetailScreenController.swift
//  Ness Botanic Garden Visitor WatchKit Extension
//
//  Created by Jake Darby on 17/02/2022.
//

import WatchKit
import Foundation


class DetailScreenController: WKInterfaceController {
    
    @IBOutlet weak var descriptionText: WKInterfaceLabel!
    @IBOutlet weak var itemImage: WKInterfaceImage!
    
    @IBOutlet weak var accessLabel: WKInterfaceLabel!
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let contextType = context as? Trail {
            setTitle(contextType.trailName)
            descriptionText.setText(contextType.description)
            itemImage.setImage(UIImage(named: "images/\(contextType.images?[0] ?? "")"))
            if contextType.accessible {
                accessLabel.setText("This trail is fully accessible")
                accessLabel.setTextColor(UIColor.green)
            }
            else {
                accessLabel.setText("This trail is not fully accessible")
                accessLabel.setTextColor(UIColor.red)
            }
        }
        else {
            let contextType = context as? Landmark
            setTitle(contextType?.name)
            descriptionText.setText(contextType?.description)
            print(contextType?.imageLink)
            itemImage.setImage(UIImage(named: "images/\(contextType?.imageLink ?? "")"))
            accessLabel.setText("")
            accessLabel.sizeToFitHeight()
        }
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
