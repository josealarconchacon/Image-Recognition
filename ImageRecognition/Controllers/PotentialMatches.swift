//
//  AddUserViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 3/4/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit

class PotentialMatches: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        print(DataPersistenceManager.documentsDirectory())
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let detailViewController = segue.destination as? PotentialMatchDetail else {
                    fatalError("indexPath, detailViewController nil")
            }
            let item = UserModel.getUser()[indexPath.row]
           detailViewController.user = item
            tableView.reloadData()
        }
    }

}
extension PotentialMatches: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserModel.getUser().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let potentialMatchesUser = UserModel.getUser()[indexPath.row]
        cell.textLabel?.text = potentialMatchesUser.name + " " + potentialMatchesUser.lastName
        cell.detailTextLabel?.text = potentialMatchesUser.dateFormattedString
    
        return cell
    }
}
extension PotentialMatches: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = UserModel.getUser()[indexPath.row]
        UserModel.delete(user: item, atIndex: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
