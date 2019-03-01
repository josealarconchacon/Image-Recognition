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
     let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/4
        imageView.clipsToBounds = true
        setTextFiel()
        setButton()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let emailImage = UIImage(named: "email-1")
        leftImageTextFiel(textField: emailTextField, image: emailImage!)
        let passwordlImage = UIImage(named: "lock-1")
        leftImagePassTextFiel(textField: passwordTextField, image: passwordlImage!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        registerKeyboardNotification()
        if userDefault.bool(forKey: "usersignedin") {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let destinationWelcomeViewController = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
            destinationWelcomeViewController.accountToT = accountTo
            self.present(destinationWelcomeViewController, animated: true, completion:  nil)
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        }
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
            if error == nil {
                // user create
                print("User Created")
            } else {
                self.showAlert(title: nil, message: "password should be 6 character long", style: .alert, handler: { (action) in })
                let _ = UIAlertAction(title: "OK", style: .default, handler: { (action) in })
                print(error!.localizedDescription)
            }
        }
    }
    
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotification()
    }
    @objc private func willShowKeyboard(notification: Notification) {
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardCenterEndUserInfoKey"] as? CGRect else {
                print("User info is nil")
                return
        }
    }
    @objc private func willHideKeyboard(notification: Notification) {
//                 baseView.transform = CGAffineTransform.identity // to put the keyboard down
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
