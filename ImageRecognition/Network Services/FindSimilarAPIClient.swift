//
//  FindSimilarAPIClient.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/5/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class FindSimilarAPIClient {
    /// Looks for the closest face in the face list.
    /// Succeeds with `nil` when the list has no similar face.
    static func fetchImageFaceInfo(faceID: String, completionHandler: @escaping (Result<ConfidenceData?, AppError>) -> Void) {
        let faceImageInfo = FaceInfo(faceId: faceID,
                                     faceListId: "newprojectfacelist",
                                     maxNumOfCandidatesReturned: 1,
                                     mode: "matchPerson")
        FaceAPI.post(path: "/findsimilars", body: faceImageInfo) { (result: Result<[ConfidenceData], AppError>) in
            completionHandler(result.map { $0.first })
        }
    }
}
