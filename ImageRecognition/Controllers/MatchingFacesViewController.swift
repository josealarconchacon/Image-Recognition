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
import Firebase
import MobileCoreServices

let APICallQueue = DispatchQueue(label: "API Queue")
class MatchingFacesViewController: UIViewController {    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var matchingResultLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var provideAditionalInfo: UIButton!
    
    
    let uploadImageRequest = DataPersistenceManager()
    var accountToT = String()
    
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    var detect = [DetectFaceUrl]()
    
    private var URLfromAPI: URL!
    private var faceIdToSend: String!
    private var matchingFaceId: String!
    private var confidenceInMatch: Double!
    private var tapGesture: UITapGestureRecognizer!
    
    private var newImageURLR: URL!
    private var newImageToSend = String()
    private var matchFound: Bool!
    private var firebaseImageURL: URL!
    private var userKeyName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        ImageManager.manager.delegate = self
        uploadImage.layer.cornerRadius = uploadImage.frame.size.width / 2
        uploadImage.clipsToBounds = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        uploadImage.addGestureRecognizer(tapGesture)
        uploadImage.isUserInteractionEnabled = true
        imagePicker.delegate = self
        setButton()

        _ = UITabBarItem(title: nil, image: UIImage(named: "match"), tag: 0)
        setButtonView()
        provideAditionalInfo.isHidden = true
        provideAditionalInfo.titleLabel?.textAlignment = .center
        matchingResultLabel.text = "Upload an image to see if there is a match"
        matchingResultLabel.textAlignment = .center
        uploadButton.isEnabled = false
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Choose Image Type", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let imageGallery = UIAlertAction(title: "Open Gallery", style: .default) { (UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.showImagePickerController()
            self.uploadButton.isEnabled = true
        }
        
        let camera = UIAlertAction(title: "Open Camera", style: .default) { (UIAlertAction) in
            print("Camera selected")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == true {
                self.showImagePickerController()
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.uploadButton.isEnabled = true
            
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
        self.uploadButton.isEnabled = true
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setButton() {
        uploadButton.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
        uploadButton.layer.cornerRadius = uploadButton.frame.height / 2
        uploadButton.setTitleColor(.black, for: .normal)
        uploadButton.layer.shadowRadius = 2
        uploadButton.layer.shadowOpacity = 0.5
        uploadButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func setButtonView() {
        provideAditionalInfo.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
        provideAditionalInfo.layer.cornerRadius = provideAditionalInfo.frame.height / 2
        provideAditionalInfo.setTitleColor(.black, for: .normal)
        provideAditionalInfo.layer.shadowRadius = 2
        provideAditionalInfo.layer.shadowOpacity = 0.5
        provideAditionalInfo.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        guard let image = uploadImage.image else { return }
        
        ImageManager.manager.uploadImage(image: image, fileName: "image") { URL in
            print("results of completion handler: ")
            self.URLfromAPI = URL
            self.firebaseImageURL = URL
            print(URL)
            
            FaceDetectAPIClient.fetchImageFaceUrl(urlInput: URL) { (data) in
                self.faceIdToSend = data.faceId
                print("Face id: ")
                print(self.faceIdToSend)
                
                self.matchFound = false
                
                FindSimilarAPIClient.fetchImageFaceInfo(faceID: self.faceIdToSend!)  { (response) in
                    print("Findsimilar data is \(response)")
                    let matchID = response.persistedFaceId
                    let confidence = response.confidence
                    self.matchingFaceId = matchID
                    self.confidenceInMatch = confidence
                    print("match id is \(matchID)")
                    print("confidence is \(confidence)")
                    self.matchFound = true
                    
                    if confidence > 0.5 {
                        DispatchQueue.main.async {
                        self.matchingResultLabel.isHidden = false
//                        self.provideAditionalInfo.isHidden = true
                        self.uploadButton.isHidden = true
                        let confidencePercent = confidence*100
                        self.matchingResultLabel.text =
                            "We found a match with \(round(confidencePercent))% confidence. \n Please provide more information and a reunification coordinator will reach out to you."
                            self.provideAditionalInfo.titleLabel!.text = "Provide more information"
                        }
                    }
                }
                if self.matchFound == false {
                    print("a match is not found")
                    DispatchQueue.main.async {
                    self.matchingResultLabel.isHidden = false
                    self.provideAditionalInfo.isHidden = false
                    self.provideAditionalInfo.titleLabel?.text = "Add to database"
                    self.matchingResultLabel.text = "Sorry, we did not find a match. \n Do you want to add this person to the database? We can contact you if their information is submitted?"
                    }
                }
            }
        }
    }

    
    @IBAction func provideMoreInfoButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let informationController = storyboard.instantiateViewController(withIdentifier: "AdditionalInformation") as? AdditionalInformation else {return}

        if self.matchFound == true {
            informationController.matchID = matchingFaceId
            informationController.confidence = confidenceInMatch
            informationController.firebaseImageURLString = firebaseImageURL.absoluteString
            informationController.userKeyName = userKeyName
            informationController.newImageToSend = newImageToSend
        }
        
        if self.matchFound == false {
            guard let newFace = uploadImage.image else { return }
            ImageManager.manager.uploadImage(image: newFace, fileName: "image") { URL in
                print("New results of completion handler: ")
                    self.newImageURLR = URL
                    informationController.firebaseImageURLString = self.newImageURLR.absoluteString
                    print(URL)
//                AddFaceToFaceList.addFace(imageURL: self.newImageURLR.absoluteString, completionHandler: { (faceId) in
//                    if let faceId = faceId {
//                        print("found id: \(faceId)")
//                    } else {
//                        print("id is nil")
//                    }
//
//                })
            }
        }
        self.present(informationController, animated: true, completion: nil)
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

    private func showImagePickerController() {
        present(imagePicker,animated: true,completion:  nil)
    }
}

extension MatchingFacesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage.image = image
            uploadImage.contentMode = UIView.ContentMode.scaleAspectFit
            selectedImage = image
//            guard let data = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        } else {
            print("Image is nil")
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MatchingFacesViewController: ImageManagerDelegate {
    func didFetchImage(_ storageManager: ImageManager, imageURL: URL) {
        DatabaseManager.updateImageURL(photoURL: imageURL)
    }
}
