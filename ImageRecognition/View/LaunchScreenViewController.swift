//
//  LaunchScreenViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/27/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    @IBOutlet fileprivate weak var launchScreen: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2.0, animations: {
            self.launchScreen.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.size.height)
            self.view.backgroundColor = UIColor.white
        }) { (success) in
            let x = UIStoryboard(name: "Main", bundle: nil)
            let vc = x.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
}
