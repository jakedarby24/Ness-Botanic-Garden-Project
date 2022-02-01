//
//  AppDelegate.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 22/11/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadDataCheck()
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
    
    lazy var persistentContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "Attractions")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        // MARK: - Core Data Saving support
        
        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    private func preloadDataCheck() {
        let key = "didLoadData"
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: key) == false {
        
            guard let attractionsURL = Bundle.main.url(forResource: "attractions", withExtension: "plist") else { return }
            guard let featuresURL = Bundle.main.url(forResource: "features", withExtension: "plist") else { return }
            guard let gardensURL = Bundle.main.url(forResource: "garden_sections", withExtension: "plist") else { return }
        
            /* The if statements below attempt to return the data stored in the plist files.
            In the following format:
            Item 0 is whether the attraction is currently active
            Item 1 is the name of the attraction
            Item 2 is the description of the attraction
            Item 3 is the latitude
            Item 4 is the longitude */
            if let attractionsContents = NSArray(contentsOf: attractionsURL) as? [[Any]] {
                for item in attractionsContents {
                    print(item)
                }
            }
            if let featuresContents = NSArray(contentsOf: featuresURL) as? [[Any]] {
                for item in featuresContents {
                    print(item)
                }
            }
            if let gardensContents = NSArray(contentsOf: gardensURL) as? [[Any]] {
                for item in gardensContents {
                    print(item)
                }
            }
            
            userDefaults.set(true, forKey: key)
        }
    }
}

