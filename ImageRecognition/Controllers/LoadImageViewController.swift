//
//  LoadImageViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/17/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit // This is test


class LoadImageViewController: UIViewController {
  
    @IBOutlet weak var tableViewFace: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersistenceFaceDetectionAPIClient.fetchImageFaceInfo()
    }
}

