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
    
    func addUser() {
        let userToAdd = ["id": Auth.auth().currentUser!.uid,
                         "firstName": firstNameTextField.text! as String,
                         "lastName" : lastNameTextField.text! as String,
                         "age"      : ageTextField.text! as String,
                         "country"  : countryTextField.text! as String,
                         "matchID"  : matchID,
                         "confidence": confidence,
                         "firebaseURLString": firebaseImageURLString
                         
            ] as [String : Any]
        ref.addDocument(data: userToAdd)
        labelText.text = "Successfully Added it"
        print(userToAdd)
        
        UIView.animate(withDuration: 5.0, delay: 0, options: [.curveEaseIn], animations: {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "MatchTabViewController") as? MatchTabViewController else {return}

            self.present(destinationViewController, animated: true, completion:  nil)
        })
        
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
        // Post to firebase
        addUser()
       
        guard let name = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let age = ageTextField.text,
            let country = countryTextField.text else {fatalError("user is nil")}

        let date = Date()
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate,
                                          .withFullTime,
                                          .withInternetDateTime,
                                          .withTimeZone,
                                          .withDashSeparatorInDate]
        let timestamp = isoDateFormatter.string(from: date)
        let user = User.init(name: name, lastName: lastName, country: country, createdAt: timestamp, confidence: confidence, matchID: matchID, age: age, firebaseImageURLString: firebaseImageURLString)
        
        UserModel.addItem(item: user)

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
