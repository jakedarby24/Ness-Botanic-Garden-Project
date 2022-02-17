//
//  trailDetailController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 14/02/2022.
//

import UIKit
import CoreLocation
import MapKit

class trailDetailController: UIViewController {
    
    @IBOutlet weak var trailNameLabel: UILabel!
    @IBOutlet weak var trailDescLabel: UILabel!
    @IBOutlet weak var trailDistanceLabel: UILabel!
    @IBOutlet weak var trailAccessibleLabel: UILabel!
    
    @IBOutlet weak var images: UIImageView!
    
    var trailName: String?
    var trailDesc: String?
    var trailDist: Double?
    var accessible: Bool?
    var trailCoords: [CLLocationCoordinate2D]?
    var imageLinks: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
            var imagesListArray = [UIImage]()
            for i in imageLinks! {
                imagesListArray.append(UIImage(named: "images/\(i)")!)
            }
            self.images.animationImages = imagesListArray
            self.images.animationDuration = Double(imagesListArray.count) * 3.0
            self.images.startAnimating()
        }
    }

}
