//
//  trailViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 07/02/2022.
//

import UIKit
import MapKit

class trailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, XMLParserDelegate {
    
    @IBOutlet weak var trailMap: MKMapView!
    @IBOutlet weak var trailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailMap.delegate = self
        trailTable.delegate = self
        trailTable.dataSource = self

        // Do any additional setup after loading the view.
        mapSetUp(mapView: trailMap)
    }
    
    //MARK: - Delegate Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        if indexPath.section == 1 {
            content.text = "Tree trail (full)"
        }
        else {
            switch indexPath.row {
            case 0:
                content.text = "Main route"
                break
            case 1:
                content.text = "Landscape route"
                break
            case 2:
                content.text = "Meadow route"
                break
            default:
                break
            }
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Nature trails"
        }
        else {
            return "Tree trails"
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        switch overlay.title {
        case "mainTrail":
            polylineRenderer.strokeColor = UIColor.systemGreen
        case "landscapeTrail":
            polylineRenderer.strokeColor = UIColor.systemBlue
        case "meadowTrail":
            polylineRenderer.strokeColor = UIColor.systemOrange
        default:
            polylineRenderer.strokeColor = UIColor.purple.withAlphaComponent(0.55)
        }
        
        polylineRenderer.lineWidth = 3
        return polylineRenderer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            if trailMap.overlays.count > 1 {
                removePolyLine(overlay: trailMap.overlays[1], mapView: trailMap)
            }
            drawPolyLine(lineName: "mainTrail", vertices: mainRouteTrail, mapView: trailMap)
        }
        else if indexPath.section == 0 && indexPath.row == 1 {
            if trailMap.overlays.count > 1 {
                removePolyLine(overlay: trailMap.overlays[1], mapView: trailMap)
            }
            drawPolyLine(lineName: "landscapeTrail", vertices: landscapeRouteTrail, mapView: trailMap)
        }
        else if indexPath.section == 0 && indexPath.row == 2 {
            if trailMap.overlays.count > 1 {
                removePolyLine(overlay: trailMap.overlays[1], mapView: trailMap)
            }
            drawPolyLine(lineName: "meadowTrail", vertices: meadowRouteTrail, mapView: trailMap)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

}
