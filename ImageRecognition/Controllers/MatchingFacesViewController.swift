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
//import AWSCore
//import AWSS3

class MatchingFacesViewController: UIViewController {
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var matchingResultLabel: UILabel!
    let uploadImageRequest = DataPersistenceManager()
    
    
    let faceIDtoSend = "757e318d-f0f5-469f-a8e5-bfa6a888c1b0"
    let urlToSend = URL(string: "https://resources.stuff.co.nz/content/dam/images/1/m/u/4/l/b/image.related.StuffLandscapeSixteenByNine.710x400.1msgyb.png/1510688122869.jpg")
    
    private var camera: UIToolbar!
    private var imagePickerController = UIImagePickerController()
    var selectedImage = UIImage()
    var detect = [DetectFaceUrl]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImage.layer.cornerRadius = uploadImage.frame.size.width / 2
        uploadImage.layer.masksToBounds = true
        let imagePicker:UIImagePickerController?=UIImagePickerController()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        uploadImage.addGestureRecognizer(tapGesture)
        uploadImage.isUserInteractionEnabled = true
        imagePicker?.delegate=self
        setupImagePickerController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        // image will be upload
        let newFaceId = FaceDetectAPIClient.fetchImageFaceUrl(urlInput: urlToSend!) { (data) in
            print("DATA IS \(data)")
        }
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
