//
//  MatchingFacesViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/4/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Photos
import UserNotifications
import UIKit

class MatchingFacesViewController: UIViewController {
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var matchingResultLabel: UILabel!
    
    private var camera: UIToolbar!
    private var imagePickerController = UIImagePickerController()
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUI()
        let imagePicker:UIImagePickerController?=UIImagePickerController()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        uploadImage.addGestureRecognizer(tapGesture)
        uploadImage.isUserInteractionEnabled = true
        imagePicker?.delegate=self
        setupImagePickerController()
    }
    func imageUI() {
        uploadImage.layer.borderWidth = 1
        uploadImage.layer.masksToBounds = false
        uploadImage.layer.borderColor = UIColor.black.cgColor
        uploadImage.layer.cornerRadius = uploadImage.frame.height/2
        uploadImage.clipsToBounds = true
    }
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        let alertController = UIAlertController(title: "Imge Profile", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let imageGallery = UIAlertAction(title: "Open Gallry", style: .default) { (UIAlertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.showImagePickerController()
        }
        let camera = UIAlertAction(title: "Open Camera", style: .default) { (UIAlertAction) in}
        let cancel  = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in  }
        alertController.addAction(imageGallery)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    private func setupImagePickerController() {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
    }
    private func showImagePickerController() {
        present(imagePickerController,animated: true,completion:  nil)
    }
}
extension MatchingFacesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage.image = image
            selectedImage = image
        } else {
            print("Image is nil")
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
