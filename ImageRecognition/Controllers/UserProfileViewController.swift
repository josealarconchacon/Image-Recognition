//
//  UserProfileViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/26/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DropDown

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    
    let dropDown = DropDown()
    var contactList = ["email", "contacts"]
    let userDefault = UserDefaults.standard
    var accountTo = String()
    var lineView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setToUI()
        guard let email = Auth.auth().currentUser?.email else { return}
        userEmail.text = email
        
        lineView = UIView(frame: CGRect(x: 110, y: 100, width: 150, height: 1.0))//#121212
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.black.cgColor
//        self.view.addSubview(lineView)
        tableView.tableFooterView = UIView()
    }
    
    func setToUI() {
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        imageProfile.clipsToBounds = true
        
        signOutButton.backgroundColor = UIColor(red: 1, green: 0.556, blue: 0.232, alpha: 1)
        signOutButton.layer.cornerRadius = 7
        signOutButton.setTitleColor(UIColor.white, for: .normal)
    }

    @IBAction func signOutButtonPress(_ sender: UIButton) {
        signOut()
    }

    /// Asks for confirmation; signs out only when the user taps OK.
    func signOut() {
        let alerController = UIAlertController(title: userEmail.text, message: "Are you sure you want to Logout?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            do {
                try Auth.auth().signOut()
            } catch {
                self.showAlert(title: "Could not log out", message: error.localizedDescription, actionTitle: "OK")
                return
            }
            self.userDefault.removeObject(forKey: "usersignedin")
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let destination = storyboard.instantiateViewController(withIdentifier: "MainePageViewController") as? MainePageViewController else {return}
            destination.sigIn = self.accountTo
            // Replace the whole screen stack instead of presenting on top of it.
            self.view.window?.rootViewController = destination
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alerController.addAction(okAction)
        alerController.addAction(cancel)
        alerController.popoverPresentationController?.sourceView = signOutButton
        alerController.popoverPresentationController?.sourceRect = signOutButton.bounds
        self.present(alerController, animated:  true)
    }
}
extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let list = contactList[indexPath.row]
        cell.textLabel?.text = list
        return cell
    }
}
