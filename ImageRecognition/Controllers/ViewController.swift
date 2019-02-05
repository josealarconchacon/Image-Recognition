//
//  ViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/17/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var baseView: UIView!
    
    var create = String ()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       textFieldEmail.delegate = self
        textFieldPassword.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
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
//        print(info)
        baseView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
    }
    @objc private func willHideKeyboard(notification: Notification) {
         baseView.transform = CGAffineTransform.identity // to put the keyboard down
    }
    @IBAction func createAccountPress(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "account") as? CreateAccountViewController  else {return}
        destinationViewController.accountTo = create
        self.present(destinationViewController, animated: true, completion:  nil)
    }
    @IBAction func signInButtonPress(_ sender: UIButton) {
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
