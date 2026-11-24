//
//   AddFaceToFaceList.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 3/5/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class AddFaceToFaceList {
    /// Adds the face in the image at `imageURL` to the "newprojectfacelist" face list
    /// (the list FindSimilarAPIClient searches) and returns its persistedFaceId.
    static func addFace(imageURL: URL, completionHandler: @escaping (Result<String, AppError>) -> Void) {
        FaceAPI.post(path: "/facelists/newprojectfacelist/persistedFaces",
                     body: DetectFaceUrl(url: imageURL)) { (result: Result<RequestFace, AppError>) in
            switch result {
            case .success(let face):
                if let id = face.persistedFaceId {
                    completionHandler(.success(id))
                } else {
                    completionHandler(.failure(.noFaceDetected))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
