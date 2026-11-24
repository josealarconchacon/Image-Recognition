//
//  FaceDetectAPIClient.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/6/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class FaceDetectAPIClient {
    /// Detects the first face in the image at `urlInput`.
    /// Fails with `.noFaceDetected` when the photo contains no face.
    static func fetchImageFaceUrl(urlInput: URL, completionHandler: @escaping (Result<DetectFaceResponse, AppError>) -> Void) {
        FaceAPI.post(path: "/detect?returnFaceId=true&returnFaceLandmarks=false",
                     body: DetectFaceUrl(url: urlInput)) { (result: Result<[DetectFaceResponse], AppError>) in
            switch result {
            case .success(let faces):
                if let face = faces.first {
                    completionHandler(.success(face))
                } else {
                    completionHandler(.failure(.noFaceDetected))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
