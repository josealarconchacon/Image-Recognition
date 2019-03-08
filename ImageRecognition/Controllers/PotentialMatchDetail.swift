//
//  AddUserDetailController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 3/4/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit

class PotentialMatchDetail: UIViewController {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var confidence: UILabel!
    @IBOutlet weak var age: UILabel!
    
    var user: User!
    var newImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NEW IMAGE IS -->> ")
        print(user.firebaseImageURLString)
        firstName.text = "First name is:  \(user.name)"
        lastName.text = "Last name:  \(user.lastName)"
        countryName.text = "Country:  \(user.country)"
        confidence.text = "Confidence:  \(user.confidence.description)"
        age.text = "Age is: \(user.age)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let imageLocation = URL(string: user.firebaseImageURLString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageLocation) {
                    DispatchQueue.main.async {
                        self.userImage.image = UIImage(data: data)
                        self.userImage.contentMode = UIView.ContentMode.scaleAspectFit
                        
                    }
                }
            }
        } else {
            print("not a valid URL")
        }
    }
    
    
}


