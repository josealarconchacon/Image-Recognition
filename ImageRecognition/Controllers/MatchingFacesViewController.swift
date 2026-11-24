//
//  MatchingFacesViewController.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/7/19.
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

    /// Matches below this confidence are treated as "no match".
    private let matchThreshold = 0.5
    private static let initialPrompt = "Upload an image to see if there is a match"

    let uploadImageRequest = DataPersistenceManager()
    var accountToT = String()

    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    var detect = [DetectFaceUrl]()

    private var tapGesture: UITapGestureRecognizer!

    // Result of the last search. nil until a search has finished.
    private var matchFound: Bool?
    private var matchingFaceId = ""
    private var confidenceInMatch = 0.0
    private var firebaseImageURL: URL?
    private var userKeyName = String()
    private var newImageToSend = String()

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

        setButtonView()
        provideAditionalInfo.titleLabel?.textAlignment = .center
        matchingResultLabel.textAlignment = .center
        resetSearchState()
        uploadButton.isEnabled = false
    }

    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Choose Image Type", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let imageGallery = UIAlertAction(title: "Open Gallery", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.showImagePickerController()
        }

        let camera = UIAlertAction(title: "Open Camera", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // Configure the picker before presenting it, or it opens the photo library.
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = false
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.showImagePickerController()
            } else {
                self.present(self.showAlert(Title: "Camera unavailable", Message: "The camera is not available on this device, or access to it has been revoked."), animated: true, completion: nil)
            }
        }

        let cancel  = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(imageGallery)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame
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

    func setButtonView() {
        provideAditionalInfo.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
        provideAditionalInfo.layer.cornerRadius = provideAditionalInfo.frame.height / 2
        provideAditionalInfo.setTitleColor(.black, for: .normal)
        provideAditionalInfo.layer.shadowRadius = 2
        provideAditionalInfo.layer.shadowOpacity = 0.5
        provideAditionalInfo.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    private func resetSearchState() {
        matchFound = nil
        matchingFaceId = ""
        confidenceInMatch = 0
        firebaseImageURL = nil
        provideAditionalInfo.isHidden = true
        uploadButton.isHidden = false
        matchingResultLabel.isHidden = false
        matchingResultLabel.text = MatchingFacesViewController.initialPrompt
    }

    @IBAction func uploadButton(_ sender: UIButton) {
        guard let image = uploadImage.image else { return }
        resetSearchState()
        uploadButton.isEnabled = false
        matchingResultLabel.text = "Searching for a match…"

        // Each step starts only after the previous one has finished:
        // upload → detect face → find similar → show result.
        ImageManager.manager.uploadImage(image: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.showSearchError("The image could not be uploaded. \(error.localizedDescription)")
            case .success(let url):
                self.firebaseImageURL = url
                FaceDetectAPIClient.fetchImageFaceUrl(urlInput: url) { result in
                    switch result {
                    case .failure(let error):
                        self.showSearchError(error.errorMessage())
                    case .success(let face):
                        FindSimilarAPIClient.fetchImageFaceInfo(faceID: face.faceId) { result in
                            switch result {
                            case .failure(let error):
                                self.showSearchError(error.errorMessage())
                            case .success(let candidate):
                                self.showMatchResult(candidate)
                            }
                        }
                    }
                }
            }
        }
    }

    private func showMatchResult(_ candidate: ConfidenceData?) {
        uploadButton.isEnabled = true
        provideAditionalInfo.isHidden = false
        if let candidate = candidate, candidate.confidence > matchThreshold {
            matchFound = true
            matchingFaceId = candidate.persistedFaceId
            confidenceInMatch = candidate.confidence
            matchingResultLabel.text =
                "We found a match with \(Int(round(candidate.confidence * 100)))% confidence. \n Please provide more information and a reunification coordinator will reach out to you."
            provideAditionalInfo.setTitle("Provide more information", for: .normal)
        } else {
            matchFound = false
            matchingResultLabel.text = "Sorry, we did not find a match. \n Do you want to add this person to the database? We can contact you if their information is submitted."
            provideAditionalInfo.setTitle("Add to database", for: .normal)
        }
    }

    private func showSearchError(_ message: String) {
        print("Search failed: \(message)")
        uploadButton.isEnabled = true
        provideAditionalInfo.isHidden = true
        matchingResultLabel.text = message
    }

    @IBAction func provideMoreInfoButton(_ sender: UIButton) {
        // The photo was already uploaded during the search, so reuse its URL.
        guard let matchFound = matchFound, let imageURL = firebaseImageURL else { return }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let informationController = storyboard.instantiateViewController(withIdentifier: "AdditionalInformation") as? AdditionalInformation else {return}

        informationController.firebaseImageURLString = imageURL.absoluteString
        informationController.userKeyName = userKeyName
        informationController.newImageToSend = newImageToSend
        if matchFound {
            informationController.matchID = matchingFaceId
            informationController.confidence = confidenceInMatch
        }
        self.present(informationController, animated: true, completion: nil)
    }

    func present(){
        self.present(imagePicker, animated: true, completion: nil)
    }

    func showAlert(Title : String!, Message : String!)  -> UIAlertController {
        let alertController : UIAlertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: .default)
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
            // A new photo invalidates the previous result.
            resetSearchState()
            uploadButton.isEnabled = true
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
