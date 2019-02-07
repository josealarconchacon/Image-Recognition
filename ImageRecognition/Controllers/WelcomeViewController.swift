//
//  WelcomeViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/17/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var importantInformationTextView: UITextView!
    @IBOutlet weak var ckexkBoxButton: UIButton!
    
    var accountToT = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        importantInformationTextView.text = "tttttttttttttt"
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
    }
    @IBAction func ckeckMarkWassPress(_ sender: UIButton) { // Check Mark B
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (done) in
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
}
