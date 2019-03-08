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

class UserProfileViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    let userDefault = UserDefaults.standard
    var accountTo = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let email = Auth.auth().currentUser?.email else { return}
        userEmail.text = email
    }
    

    @IBAction func signOutButtonPress(_ sender: UIButton) {
        signOut()
        do {
            try Auth.auth().signOut()
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            
        } catch let error as NSError {
            print(error.localizedDescription)
            print("Loging Out")
        }
    }
    
    func signOut() {
        let alerController = UIAlertController(title:" \(userEmail.text!)", message: " Are you sure you want to Logout?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let destination = storyboard.instantiateViewController(withIdentifier: "MainePageViewController") as? MainePageViewController else {return}
            destination.sigIn = self.accountTo
            self.present(destination, animated: true, completion:  nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alerController.addAction(okAction)
        alerController.addAction(cancel)
        self.present(alerController, animated:  true)

    }
}
