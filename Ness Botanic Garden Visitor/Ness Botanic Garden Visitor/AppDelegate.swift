//
//  AppDelegate.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 22/11/2021.
//

import UIKit
import MapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let attractions = getPlacesFromPlist(fileName: "attractions")
        
        // Get the name of the attraction from the notification
        var notificationContent = response.notification.request.content.body
        notificationContent.removeFirst(12)
        notificationContent = notificationContent.components(separatedBy: ".")[0]
        var coordinates: CLLocationCoordinate2D?
        var attractionDescription: String?
        var attractionImage: String?
        for i in attractions! {
            if i.name == notificationContent {
                coordinates = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
                attractionDescription = i.description
                attractionImage = i.imageLink
            }
        }
        
        // Create a new view controller to display
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }

        // Initialise the view controller with the correct information from the notification
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = storyboard.instantiateViewController(identifier: "TabBarController") as! UITabBarController
        let detailViewController = storyboard.instantiateViewController(identifier: "PlaceDetailController") as! placeDetailViewController
        detailViewController.titleName = notificationContent
        detailViewController.position = coordinates
        detailViewController.descriptionName = attractionDescription
        detailViewController.imageLink = attractionImage
        tabController.selectedIndex = 3
        window.rootViewController = tabController
        window.makeKeyAndVisible()
        window.rootViewController?.present(detailViewController, animated: true, completion: nil)
        completionHandler()
    }
}
