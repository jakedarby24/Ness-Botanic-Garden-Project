//
//  trailPinDetailController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 28/02/2022.
//

import UIKit

class trailPinDetailController: UIViewController {

    @IBOutlet weak var pinTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var pinTitle: String?
    var pinDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinTitleLabel.text = pinTitle
        descriptionTextView.text = pinDescription
    }
}
