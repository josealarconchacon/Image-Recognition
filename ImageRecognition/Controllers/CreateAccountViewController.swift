//
//  CreateAccountViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/17/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var signInLabel: UILabel!
    
    
    var accountTo = String()
    var issigIn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/4
        imageView.clipsToBounds = true
        setTextFiel()
        setButton()
        handSignUo()
    }
    func setTextFiel() {
        emailTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 10.0
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 10.0
    }
    func setButton() {
        create.backgroundColor = UIColor.darkGray
        create.layer.cornerRadius = create.frame.height / 2
        create.setTitleColor(.white, for: .normal)
        create.layer.shadowRadius = 2
        create.layer.shadowOpacity = 0.5
        create.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

     func handSignUo() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil && user == user {
                print("User was created!!!")
            } else {
                print("Error is: \(error?.localizedDescription)")
            }
        }
        issigIn = !issigIn
        if issigIn {
            signInLabel.text = "Sig In"
            create.setTitle("Sign In", for: .normal)
        } else {
            signInLabel.text = "Sig Up"
            create.setTitle("Sign Up", for: .normal)
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func createButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationCreateVC = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
        destinationCreateVC.accountToT = accountTo
        self.present(destinationCreateVC, animated: true, completion: nil)
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            if issigIn {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let user = user {
                         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        guard let destinationCreateVC = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
                        destinationCreateVC.accountToT = self.accountTo
                        self.present(destinationCreateVC, animated: true, completion: nil)
                    }
                    else {
                        
                    }
                }
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { (user, password) in
                    if let user = user {
//                        self.performSegue(withIdentifier: "account1", sender: self)
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        guard let destinationCreateVC = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
                        destinationCreateVC.accountToT = self.accountTo
                        self.present(destinationCreateVC, animated: true, completion: nil)
                    }
                    else {
                        
                    }
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case passwordTextField:
            handSignUo()
//            passwordTextField.resignFirstResponder()
//            passwordTextField.becomeFirstResponder()
        default:
            break
        }
        textField.resignFirstResponder()
        return true
    }
}
