//
//  MainePageViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/25/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Firebase

class MainePageViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var sigIn = String ()
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }
    
    func setButton() {
        logInButton.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
        logInButton.layer.cornerRadius = logInButton.frame.height / 2
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.layer.shadowRadius = 2
        logInButton.layer.shadowOpacity = 0.5
        logInButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        signUpButton.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.shadowRadius = 2
        signUpButton.layer.shadowOpacity = 0.5
        signUpButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @IBAction func ligIn(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destination = storyboard.instantiateViewController(withIdentifier: "singIn") as? ViewController else {return}
        destination.create = sigIn
        self.present(destination, animated: true, completion:  nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destination = storyboard.instantiateViewController(withIdentifier: "account") as?  CreateAccountViewController else { return}
        destination.accountTo = sigIn
        self.present(destination, animated: true, completion:  nil)
    }
}
