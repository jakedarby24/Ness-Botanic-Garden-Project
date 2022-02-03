//
//  floraListViewController.swift
//  Ness Botanic Garden Visitor
//
//  Created by Jake Darby on 03/02/2022.
//

import UIKit

class floraListViewController: UITableViewController {

    var attractions : [Landmark]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        attractions = getItemsFromPlist(fileName: "attractions")
        return attractions!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        attractions = getItemsFromPlist(fileName: "attractions")
        let cell = tableView.dequeueReusableCell(withIdentifier: "floraCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = attractions?[indexPath.row].name
        if attractions?[indexPath.row].imageLink != nil {
            content.image = UIImage(named: "images/\(attractions?[indexPath.row].imageLink ?? "")")
            content.imageProperties.maximumSize = CGSize(width: 120, height: 96)
        }
        cell.contentConfiguration = content
        return cell
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
