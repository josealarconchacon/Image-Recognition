//
//  CreateAccountViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/17/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var accountTo = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/4
        imageView.clipsToBounds = true
        setTextFiel()
    }
    func setTextFiel() {
        firstNameTextField.clipsToBounds = true
        firstNameTextField.layer.cornerRadius = 10.0
        lastNameTextField.clipsToBounds = true
        lastNameTextField.layer.cornerRadius = 10.0
        emailTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 10.0
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 10.0
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func createButtonPress(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationCreateVC = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
        destinationCreateVC.accountToT = accountTo
        self.present(destinationCreateVC, animated: true, completion: nil)
    }
}
