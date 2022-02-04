//
//  attractionListViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 01/02/2022.
//

import UIKit
import MapKit

class attractionListViewController: UITableViewController {
    
    var sections: [Landmark]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections = getItemsFromPlist(fileName: "garden_sections")
        return sections!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sections = getItemsFromPlist(fileName: "garden_sections")
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = sections?[indexPath.row].name
        if sections?[indexPath.row].imageLink != nil {
            content.image = UIImage(named: "images/\(sections?[indexPath.row].imageLink ?? "")")
            content.imageProperties.maximumSize = CGSize(width: 120, height: 96)
        }
        cell.contentConfiguration = content
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetailFromTable" {
            let selectedRow = tableView.indexPath(for: sender as! UITableViewCell)
            let secondViewController = segue.destination as! placeDetailViewController
            secondViewController.titleName = sections![selectedRow!.row].name
            secondViewController.descriptionName = sections![selectedRow!.row].description
            secondViewController.position = CLLocationCoordinate2D(latitude: sections![selectedRow!.row].latitude, longitude: sections![selectedRow!.row].longitude)
        }
    }

}
