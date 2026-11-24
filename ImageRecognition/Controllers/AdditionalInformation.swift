//
//  AdditionalInformationController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 3/3/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AdditionalInformation: UIViewController {
    
    @IBOutlet var additionalInfo: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sideButton: UIButton!
    
    var confidence: Double = 0.0
    var matchID: String = ""
    var age: String = ""
    var firebaseImageURLString = ""
    var imageInfo: UIImage?
    var userKeyName = String()
    var newImageToSend = String()
    
    var ref: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        ageTextField.delegate = self
        countryTextField.delegate = self
        setTextField()
        setButton()
        ref = Firestore.firestore().collection("users")
    }
    
    private func trimmedText(_ textField: UITextField) -> String {
        return (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Saves the person to Firestore, then locally, then returns to the main tabs.
    func addUser() {
        guard let currentUser = Auth.auth().currentUser else {
            showAlert(title: "Not signed in", message: "Please log in again before adding a person.", actionTitle: "OK")
            return
        }
        let name = trimmedText(firstNameTextField)
        let lastName = trimmedText(lastNameTextField)
        let age = trimmedText(ageTextField)
        let country = trimmedText(countryTextField)
        guard !name.isEmpty, !lastName.isEmpty else {
            showAlert(title: "Missing information", message: "Please enter at least a first and last name.", actionTitle: "OK")
            return
        }

        let userToAdd = ["id": currentUser.uid,
                         "firstName": name,
                         "lastName" : lastName,
                         "age"      : age,
                         "country"  : country,
                         "matchID"  : matchID,
                         "confidence": confidence,
                         "firebaseURLString": firebaseImageURLString
            ] as [String : Any]

        addButton.isEnabled = false
        labelText.text = "Saving…"
        ref.addDocument(data: userToAdd) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.addButton.isEnabled = true
                self.labelText.text = nil
                self.showAlert(title: "Could not save", message: error.localizedDescription, actionTitle: "OK")
                return
            }
            let timestamp = ISO8601DateFormatter().string(from: Date())
            let user = User(name: name, lastName: lastName, country: country, createdAt: timestamp,
                            confidence: self.confidence, matchID: self.matchID, age: age,
                            firebaseImageURLString: self.firebaseImageURLString)
            UserModel.addItem(item: user)
            self.labelText.text = "Successfully Added it"

            // Show the confirmation briefly, then replace the screen stack with the main tabs.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "MatchTabViewController") as? MatchTabViewController else {return}
                self.view.window?.rootViewController = destinationViewController
            }
        }
    }
    
    func setTextField() {
        firstNameTextField.textFieldPaddingView()
        lastNameTextField.textFieldPaddingView()
        ageTextField.textFieldPaddingView()
        countryTextField.textFieldPaddingView()
        
        firstNameTextField.textFieldBottomBorder()
        lastNameTextField.textFieldBottomBorder()
        ageTextField.textFieldBottomBorder()
        countryTextField.textFieldBottomBorder()
    }
    func setButton() {
        addButton.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.setTitleColor(.black, for: .normal)
        addButton.layer.shadowRadius = 2
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @IBAction func addInfoButtonPress(_ sender: UIButton) {
        addUser()
    }
    
    @IBAction func backButtonPress(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sideButtonPress(_ sender: UIButton) {

    }
}

extension AdditionalInformation: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension UITextField {
    func textFieldPaddingView() {
        let paddingTFView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingTFView
        self.leftViewMode = .always
    }
    
    func textFieldBottomBorder() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
