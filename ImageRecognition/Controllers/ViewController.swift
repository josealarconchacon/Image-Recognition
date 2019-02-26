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

class ViewController: UIViewController {
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var create = String ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        setButton()
        setTextField()
        textFieldEmail.addTarget(self, action: #selector(textFieldDropDown), for: .touchDown)
        if let userName = UserDefaults.standard.object(forKey: UserDefaultKey.userEmailKey) as? String {
            textFieldEmail.text = userName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
    }
    @objc func textFieldDropDown() {

    }
    func setButton() {
        continueButton.backgroundColor = UIColor.darkGray
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.shadowRadius = 2
        continueButton.layer.shadowOpacity = 0.5
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    func setTextField() {
        textFieldEmail.clipsToBounds = true
        textFieldEmail.layer.cornerRadius = 10.0
        textFieldEmail.clipsToBounds = true
        textFieldEmail.layer.cornerRadius = 10.0
        
        textFieldPassword.clipsToBounds = true
        textFieldPassword.layer.cornerRadius = 10.0
        textFieldPassword.clipsToBounds = true
        textFieldPassword.layer.cornerRadius = 10.0
        
    }
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
//         baseView.transform = CGAffineTransform.identity // to put the keyboard down
    }
   
    @IBAction func createAccountPress(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "account") as? CreateAccountViewController  else {return}
        destinationViewController.accountTo = create
        self.present(destinationViewController, animated: true, completion:  nil)
    }
    
    @IBAction func continueButtonPress(_ sender: UIButton) {
        if let text = textFieldEmail.text {
            UserDefaults.standard.set(text, forKey: UserDefaultKey.userEmailKey)
        }
            
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationWelcomeViewController = storyboard.instantiateViewController(withIdentifier: "account1") as? WelcomeViewController else {return}
        destinationWelcomeViewController.accountToT = create
        self.present(destinationWelcomeViewController, animated: true, completion:  nil)
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        
    }
}
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
