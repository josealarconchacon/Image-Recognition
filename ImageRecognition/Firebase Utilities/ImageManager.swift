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

protocol ImageManagerDelegate: AnyObject { // to get the imageURL
    func didFetchImage(_ storageManager: ImageManager, imageURL: URL)
}

final class ImageManager {
    weak var delegate: ImageManagerDelegate?

    public let imageStorage = Storage.storage()
    private lazy var imageStorageRef = imageStorage.reference()
    // to create an Images Storege
    private lazy var imageRef = imageStorageRef.child("faceR")

    static var manager = ImageManager()
    private init(){}
    // Uploading Image
    func uploadImage(image: UIImage, fileName: String) {
        let imageRef = imageStorageRef.child(fileName)
        let metaData = StorageMetadata()
        metaData.cacheControl = "public,max-age=300"
        metaData.contentType = "image/png"
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print(" Error is: \(error)")
            }
            else  if let metadata = metadata {
                let imageBox = ImageBox(fileName: fileName)
                DatabaseManager.saveImage(fox: imageBox)
                print(metadata.size)
            
            }
        }
    }
    func downloadImage(fileName: String, completion: @escaping((UIImage) -> Void)) {
        let refImage = imageRef.child(fileName)
        refImage.downloadURL { (url, error) in
            if let error = error {
                print(error)
                print("Url image is \(url?.absoluteURL)")
            }
            if let url = url {
                ImageCache.shared.fetchImageFromNetwork(urlString: url.absoluteString, completion: { (appError, image) in
                    if let appError = appError {
                        print(appError)
                    }
                    if let image = image {
                        completion(image)
                        self.delegate?.didFetchImage(self, imageURL: url)
                    }
                })
            
            }
            let downloadTask = self.imageRef.child("images/mountains.jpg").write(toFile: url!)
            downloadTask.pause()
            downloadTask.resume()
            downloadTask.cancel()

        }
    }
}
