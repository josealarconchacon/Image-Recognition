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
    // Uploading Image
    func uploadImage(image: UIImage, fileName: String, completion: @escaping (URL) -> Void) {
        
        let imageRef = imageStorageRef.child(fileName)
        let metaData = StorageMetadata()
        metaData.cacheControl = "public,max-age=300"
        metaData.contentType = "image/png"
        
        var newImageURL = ""
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        imageRef.putData(imageData)
        

            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Uh-oh, an error occurred!")
                    return
                }
                
                if let url = url {
                    ImageCache.shared.fetchImageFromNetwork(urlString: url.absoluteString, completion: { (error, image) in
                        if let error = error {
                            print(error)
                        }
                        if image != nil {//if let image = image
                            self.delegate?.didFetchImage(self, imageURL: url)
                            print(url.absoluteString)
                            self.URLtoSend = downloadURL
                            print("URL IS -> \(downloadURL)")
                            newImageURL = downloadURL.absoluteString
                            print(newImageURL)
                            DispatchQueue.main.async { completion(downloadURL) }
                        }
                    })
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
