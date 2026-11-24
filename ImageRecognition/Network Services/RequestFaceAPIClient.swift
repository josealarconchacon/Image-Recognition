//
//  RequestFaceAPIClient.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/7/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class RequestFaceAPIClient {
    /// Adds the face in the image at `imageURL` to the "allfacesavailable2019" face list.
    static func fetchImageFaceUrl(imageURL: URL, completionHandler: @escaping (Result<RequestFace, AppError>) -> Void) {
        FaceAPI.post(path: "/facelists/allfacesavailable2019/persistedFaces",
                     body: DetectFaceUrl(url: imageURL),
                     completion: completionHandler)
    }
}
