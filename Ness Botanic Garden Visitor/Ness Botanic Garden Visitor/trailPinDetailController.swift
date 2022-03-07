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

        // Do any additional setup after loading the view.
        
        pinTitleLabel.text = pinTitle
        descriptionTextView.text = pinDescription
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
