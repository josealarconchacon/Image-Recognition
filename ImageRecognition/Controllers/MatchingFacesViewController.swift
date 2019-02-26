//
//  MatchingFacesViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/4/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Photos
import Foundation
import UserNotifications
//import FirebaseAuth
//import FirebaseStorage
import Firebase
import MobileCoreServices
import MBCircularProgressBar


class MatchingFacesViewController: UIViewController {    
    @IBOutlet weak var progresiveView: MBCircularProgressBarView!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var matchingResultLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    let uploadImageRequest = DataPersistenceManager()
    var accountToT = String()
    
    
    let faceIDtoSend1 = "aae98811-f42c-4c83-ae52-4b687bac1e4b"
//    let urlToSend = URL(string: "https://resources.stuff.co.nz/content/dam/images/1/m/u/4/l/b/image.related.StuffLandscapeSixteenByNine.710x400.1msgyb.png/1510688122869.jpg")
    let faceUrl = URL(string: "https://1.bp.blogspot.com/-SkV_JgzGtoc/VrL2rU1pmNI/AAAAAAABVCQ/jRza4HBjJDw/s1600/Kids%2Bheadshots_los%2Bangeles008Lane_016%2Bweb%2Bfb.jpg")
    
//    private var imagePickerController = UIImagePickerController()
    var imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    var detect = [DetectFaceUrl]()
    
//    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 1.0) {
//            self.progresiveView.value = 80
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImage.layer.borderWidth = 1
        uploadImage.layer.masksToBounds = false
        uploadImage.layer.borderColor = UIColor.lightGray.cgColor
        uploadImage.layer.cornerRadius = uploadImage.frame.height/4
        uploadImage.clipsToBounds = true
        let imagePicker:UIImagePickerController?=UIImagePickerController()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        uploadImage.addGestureRecognizer(tapGesture)
        uploadImage.isUserInteractionEnabled = true
        imagePicker?.delegate = self
        setupImagePickerController()
        setButton()
        self.progresiveView.value = 0
        
        ImageCache.shared.fetchImageFromNetwork(urlString: faceIDtoSend1) { (error, image) in
            if let error = error {
                print("Error is --\(error)")
            }
            if let image = image {
                DispatchQueue.main.async {
                    self.faceIDtoSend1
                }
            }
        }
    }
    
    func setButton() {
        uploadButton.clipsToBounds = true
        uploadButton.backgroundColor = UIColor.lightGray
        uploadButton.setTitleColor(UIColor.white, for: .normal)
        uploadButton.layer.cornerRadius = uploadButton.frame.height/2
        uploadButton.layer.shadowColor = UIColor.red.cgColor
        uploadButton.layer.shadowRadius = 6
        uploadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        // image will be upload
        UIView.animate(withDuration: 1.0) { self.progresiveView.value = 100 }
        var faceIdToSend = String()
//        FaceDetectAPIClient.fetchImageFaceUrl(urlInput: faceUrl!) { (data) in
//            faceIdToSend = data.faceId
//            print("DATA IS \(faceIdToSend)")
//        }
//        FindSimilarAPIClient.fetchImageFaceInfo(faceID: faceIDtoSend1)  { (response) in
//            //            faceIdToSend = data.faceId
//            print("Findsimilar data is \(response)")
//            let matchID = response.persistedFaceId
//            let confidence = response.confidence
//            print("match id is \(matchID)")
//            print("confidence is \(confidence)")
//        }
        //Upload Image
        guard let image = uploadImage.image else { return }
        ImageManager.manager.uploadImage(image: image, fileName: "image")
//        
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//        imagePicker.mediaTypes = [kCIAttributeTypeImage]
//        imagePicker.delegate = self
        
    }
    
    func present(){
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func showAlert(Title : String!, Message : String!)  -> UIAlertController {
        let alertController : UIAlertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            print("User pressed ok function")
        }
        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame
        return alertController
    }

    @objc func tapGesture(gesture: UIGestureRecognizer) {
        let alertController = UIAlertController(title: "Imge Profile", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let imageGallery = UIAlertAction(title: "Open Gallry", style: .default) { (UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.showImagePickerController()
        }
        let camera = UIAlertAction(title: "Open Camera", style: .default) { (UIAlertAction) in
            print("Camera selected")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == true {
                self.showImagePickerController()
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                self.imagePicker.mediaTypes = [kUTTypeImage as! String]
                //                self.present()
            } else {
                self.present(self.showAlert(Title: "Title", Message: "Photo Library is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)
            }
        }
        let cancel  = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in  }
        alertController.addAction(imageGallery)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame
        self.present(alertController, animated: true, completion: nil)
    }
    private func setupImagePickerController() {
        imagePicker = UIImagePickerController()
        self.imagePicker.sourceType = .camera
        imagePicker.delegate = self
    }
    private func showImagePickerController() {
        present(imagePicker,animated: true,completion:  nil)
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

