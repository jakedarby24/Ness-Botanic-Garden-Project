//
//  trailDetailController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 14/02/2022.
//

// Imports
import UIKit
import CoreLocation
import MapKit

class trailDetailController: UIViewController {
    
    // Outlet declaration
    @IBOutlet weak var trailNameLabel: UILabel!
    @IBOutlet weak var trailDescLabel: UILabel!
    @IBOutlet weak var trailDistanceLabel: UILabel!
    @IBOutlet weak var trailAccessibleLabel: UILabel!
    @IBOutlet weak var images: UIImageView!
    
    // Attribute declaration
    var trailName: String?
    var trailDesc: String?
    var trailDist: Double?
    var accessible: Bool?
    var trailCoords: [CLLocationCoordinate2D]?
    var imageLinks: [String]?
    var imagesListArray = [UIImage]()
    var currentImage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set all of the labels to the correct trail information
        trailNameLabel.text = trailName
        trailDescLabel.text = trailDesc
        trailDistanceLabel.text = "\(trailDist ?? 0) km long"
        if accessible! {
            trailAccessibleLabel.text = "This trail is suitable for visitors with accessibility requirements"
            trailAccessibleLabel.textColor = UIColor.systemGreen
        }
        else {
            trailAccessibleLabel.text = "This trail is not suitable for visitors with accessibility requirements"
            trailAccessibleLabel.textColor = UIColor.systemRed
        }
        
        if imageLinks != nil {
            for i in imageLinks! {
                imagesListArray.append(UIImage(named: "images/\(i)")!)
            }
            images.image = imagesListArray[0]
        }
        
    }
    
    // Image animation does not function in viewDidLoad, so viewDidAppear is necessary here
    override func viewDidAppear(_ animated: Bool) {
        
        // Call the transition function of UIView which performs a transition between two different program states
        UIView.transition(with: self.images, duration: 3.0, options: .transitionCrossDissolve, animations: { [self] in
            if !(currentImage < imagesListArray.count) {
                currentImage = 0
            }
            images.image = imagesListArray[currentImage]
            currentImage += 1
        }, completion: {
            // This code uses a recursive function to continue cycling through images
            [self]_ in DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            transitionRepeater()
        }})
    }
    
    // A recursive function that allows for the continued changing of images on the view
    func transitionRepeater() {
        UIView.transition(with: self.images, duration: 3.0, options: .transitionCrossDissolve, animations: { [self] in
            if !(currentImage < imagesListArray.count) {
                currentImage = 0
            }
            images.image = imagesListArray[currentImage]
            currentImage += 1
        }, completion: {
            // This code uses a recursive function to continue cycling through images
            [self]_ in DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            transitionRepeater()
        }})
    }
}
