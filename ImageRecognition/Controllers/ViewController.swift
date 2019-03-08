//
//  ViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/17/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
 
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!

    var imagePicker: UIImagePickerController!
    var create = String ()
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        setButton()
        setTextFieldToSet()
        let emailImage = UIImage(named: "email-1")
        leftImageTextFiel(textField: textFieldEmail, image: emailImage!)
        let passwordlImage = UIImage(named: "lock-1")
        leftImagePassTextFiel(textField: textFieldPassword, image: passwordlImage!)
        
        if let userName = UserDefaults.standard.object(forKey: UserDefaultKey.userEmailKey) as? String {
            textFieldEmail.text = userName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
        if userDefault.bool(forKey: "usersignedin") {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let destinationWelcomeViewController = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
            destinationWelcomeViewController.accountToT = create
            self.present(destinationWelcomeViewController, animated: true, completion:  nil)
            textFieldEmail.resignFirstResponder()
            textFieldPassword.resignFirstResponder()
        }
    }

    func setButton() {
        continueButton.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.layer.shadowRadius = 2
        continueButton.layer.shadowOpacity = 0.5
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func setTextFieldToSet() {
        textFieldEmail.textFieldStyle()
        textFieldPassword.textFieldStyle()
        textFieldEmail.textFieldButtonStyle()
        textFieldPassword.textFieldButtonStyle()
    }
    
    func leftImageTextFiel(textField: UITextField, image img: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        imageView.image = img
        textFieldEmail.leftView = imageView
        textFieldEmail.leftViewMode = .always
    }
    
    func leftImagePassTextFiel(textField: UITextField, image img: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        imageView.image = img
        textFieldPassword.leftView = imageView
        textFieldPassword.leftViewMode = .always
    }

    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                // sign in
                print("User Sign In")
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "MatchTabViewController") as? MatchTabViewController else {return}
                destinationViewController.match = self.create
                self.present(destinationViewController, animated: true, completion:  nil)
                
            } else if error?._code == AuthErrorCode.userNotFound.rawValue{
            } else {
                print("Error is: \(error!.localizedDescription)")
                self.showAlert(title: "Invalid email or password", message: "Please try again", style: .alert, handler: { (action) in })
                let _ = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                })
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
            let _ = info["UIKeyboardCenterEndUserInfoKey"] as? CGRect else {//keyboardFrame
                print("User info is nil")
                return
        }
    }
   
    @IBAction func continueButtonPress(_ sender: UIButton) {
          signInUser(email: textFieldEmail.text!, password: textFieldPassword.text!)
        }
    }

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func textFieldStyle() {
        let paddingTFView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingTFView
        self.leftViewMode = .always
    }
    
    func textFieldButtonStyle() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
