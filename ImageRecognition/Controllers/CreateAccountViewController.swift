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
    @IBOutlet weak var create: UIButton!
    
    var accountTo = String()
    var issigIn: Bool = true
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if userDefault.bool(forKey: "usersignedin") {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let destinationWelcomeViewController = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
            destinationWelcomeViewController.accountToT = accountTo
            self.present(destinationWelcomeViewController, animated: true, completion:  nil)
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        }
    }
    
    func setButton() {
        create.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
        create.layer.cornerRadius = create.frame.height / 2
        create.setTitleColor(.black, for: .normal)
        create.layer.shadowRadius = 2
        create.layer.shadowOpacity = 0.5
        create.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func leftImageTextFiel(textField: UITextField, image img: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        imageView.image = img
        emailTextField.leftView = imageView
        emailTextField.leftViewMode = .always
    }
    
    func leftImagePassTextFiel(textField: UITextField, image img: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        imageView.image = img
        passwordTextField.leftView = imageView
        passwordTextField.leftViewMode = .always
    }
    
    func createUser(email: String, password: String) { // new
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if result != nil {
                // user create
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                guard let destinationWelcomeViewController = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
                destinationWelcomeViewController.accountToT = self.accountTo
                self.present(destinationWelcomeViewController, animated: true, completion:  nil)
                print("User Created")
            } else {
                self.showAlert(title: nil, message: "password should be 6 character long", style: .alert, handler: { (action) in })
                let _ = UIAlertAction(title: "OK", style: .default, handler: { (action) in })
//                print(error!.localizedDescription)
                
            }
        }
    }
    
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotification()
    }
    @objc private func willShowKeyboard(notification: Notification) {
        guard let info = notification.userInfo,
            let _ = info["UIKeyboardCenterEndUserInfoKey"] as? CGRect else {
                print("User info is nil")
                return
        }
    }
    
    @IBAction func createButton(_ sender: UIButton) {
        createUser(email: emailTextField.text!, password: passwordTextField.text!)
        presentedViewController?.performSegue(withIdentifier: "account1", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

