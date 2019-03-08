//
//  WelcomeViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/17/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    @IBOutlet weak var importantInformationTextView: UITextView!
    @IBOutlet weak var ckexkBoxButton: UIButton!
    
    
    var accountToT = String()
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importantInformationTextView.text = "These Website Standard Terms And Conditions (these “Terms” or these “Website Standard Terms And Conditions”) contained herein on this webpage, shall govern your use of this website, including all pages within this website (collectively referred to herein below as this “Website”). These Terms apply in full force and effect to your use of this Website and by using this Website, you expressly accept all terms and conditions contained herein in full. You must not use this Website, if you have any objection to any of these Website Standard Terms And Conditions.This Website is not for use by any minors (defined as those who are not at least 18 years of age), and you must not use this Website if you a minor."
        
        ckexkBoxButton.setImage(UIImage(named: "icons8-unchecked_checkbox_filled"), for: .normal)
        ckexkBoxButton.setImage(UIImage(named: "icons8-checked_checkbox"), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func doneButtonPress(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationController = storyboard.instantiateViewController(withIdentifier: "loadingImage") as? MatchingFacesViewController else {return}
        self.present(destinationController, animated: true, completion: nil)
    }
    
    @IBAction func ckeckMarkWassPress(_ sender: UIButton) { // Check Mark B
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (done) in
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                self.ckexkBoxButton.backgroundColor = .green
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
}
