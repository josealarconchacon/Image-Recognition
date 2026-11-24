//
//  ImageManager.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/18/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth

// var URLtoSend: URL!
protocol ImageManagerDelegate: AnyObject { // to get the imageURL
    func didFetchImage(_ storageManager: ImageManager, imageURL: URL)
}

final class ImageManager {
   public var URLtoSend: URL!
    
    weak var delegate: ImageManagerDelegate?
     var faceIdToSend = String()
    
    public let imageStorage = Storage.storage()
    private lazy var imageStorageRef = imageStorage.reference()
    // to create an Images Storege
    private lazy var imageRef = imageStorageRef.child("faceR")// faceR

    static var manager = ImageManager()
    private init(){}
    enum UploadError: LocalizedError {
        case encodingFailed
        case missingDownloadURL
        var errorDescription: String? {
            switch self {
            case .encodingFailed: return "The image could not be encoded."
            case .missingDownloadURL: return "The upload finished but no download URL was returned."
            }
        }
    }

    /// Uploads the image under a unique name in `faceR/` and returns its download URL.
    /// The completion always runs exactly once, on the main queue.
    func uploadImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        func finish(_ result: Result<URL, Error>) {
            DispatchQueue.main.async { completion(result) }
        }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            finish(.failure(UploadError.encodingFailed))
            return
        }
        // A unique name per upload, so one user's photo never overwrites another's.
        let fileRef = imageRef.child("\(UUID().uuidString).jpg")
        let metaData = StorageMetadata()
        metaData.cacheControl = "public,max-age=300"
        metaData.contentType = "image/jpeg"

        fileRef.putData(imageData, metadata: metaData) { (_, error) in
            if let error = error {
                finish(.failure(error))
                return
            }
            // Ask for the URL only once the upload has finished.
            fileRef.downloadURL { (url, error) in
                if let error = error {
                    finish(.failure(error))
                    return
                }
                guard let url = url else {
                    finish(.failure(UploadError.missingDownloadURL))
                    return
                }
                self.URLtoSend = url
                DispatchQueue.main.async {
                    self.delegate?.didFetchImage(self, imageURL: url)
                }
                finish(.success(url))
            }
        }
    }
    
    ///
    public func postImage(data: Data, imageName: String, firstLastName: String) {
        guard let user = Auth.auth().currentUser else {
            print("No user")
            return
        }
        let newImageRef = imageRef.child(Keys.ImagesKey + "/\(imageName)").child(Keys.ImagesKey + "/\(firstLastName)")
         let metaData = StorageMetadata()
         metaData.contentType = "image/jpeg"
        let uploadTask = newImageRef.putData(data, metadata: metaData) { (meta, error) in
            guard let metadata = meta else {
                print("Error uploading data")
                return
            }
            let _ = metadata.size
            newImageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print(error)
                } else if let url = url {
                    self.delegate?.didFetchImage(self, imageURL: url)
                }
            })
        }
        // observe states on uploadTask
        uploadTask.observe(.failure) { (storageTaskSnapshot) in
            print("failure...")
        }
        uploadTask.observe(.pause) { (storageTaskSnapshot) in
            print("pause...")
        }
        uploadTask.observe(.progress) { (storageTaskSnapshot) in
            print("progress...")
        }
        uploadTask.observe(.resume) { (storageTaskSnapshot) in
            print("resume...")
        }
        uploadTask.observe(.success) { (storageTaskSnapshot) in
            print("success...")
        }
     }
}
