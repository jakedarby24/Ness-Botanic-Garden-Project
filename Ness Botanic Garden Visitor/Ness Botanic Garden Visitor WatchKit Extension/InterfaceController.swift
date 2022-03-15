//
//  InterfaceController.swift
//  Ness Botanic Garden Visitor WatchKit Extension
//
//  Created by Jake Darby on 22/11/2021.
//

import WatchKit
import Foundation
import UserNotifications

class InterfaceController: WKInterfaceController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var placeTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var placeDescriptionLabel: WKInterfaceLabel!
    @IBOutlet weak var placeImage: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var notificationContent = response.notification.request.content.body
        notificationContent.removeFirst(12)
        notificationContent = notificationContent.components(separatedBy: ".")[0]
        print(notificationContent)
        let attractions = getPlacesFromPlist(fileName: "attractions")
        for i in attractions! {
            if i.name == notificationContent {
                print(i)
                placeTitleLabel.setText(i.name)
                placeDescriptionLabel.setText(i.description)
                placeImage.setImage(UIImage(named: "Watch Images/\(i.imageLink ?? "")"))
            }
        }
    }

}
