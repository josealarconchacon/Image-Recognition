//
//  PersistenceFaceDetectionAPIClient.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/5/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class FindSimilarAPIClient {
    static func fetchImageFaceInfo(faceID: String, completionHandler: @escaping ((ConfidenceData) -> Void)) {
        let endpointURLString = "https://eastus.api.cognitive.microsoft.com/face/v1.0/findsimilars"
        guard let url = URL(string: endpointURLString) else {
            print("Bad url")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("2a4cfb8a6038416ab369fcecd73ab423", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"

        let faceImageInfo = FaceInfo.init(faceId: faceID,
//                                              faceListId: "newprojectfacelist",
                                              faceListId: "newprojectfacelist",
                                              maxNumOfCandidatesReturned: 1,
                                              mode: "matchPerson")
        do {
            let data = try JSONEncoder().encode(faceImageInfo)
            request.httpBody = data
        } catch {
            print("json encoding error: \(error)")
        }
        let task = URLSession.shared.uploadTask(with: request, from: nil) { (data, response, error) in
            if let error = error {
                print("upload task error:  \(error)")
            } else if let data = data {
                print("data: \(data)")
                do {
                    let confidenceData = try JSONDecoder().decode([ConfidenceData].self, from: data)
                    guard let dataUnwrapped = confidenceData.first else {return}
                    completionHandler(dataUnwrapped)
//                    print(confidenceData)
                } catch {
                    print("decoding error: \(error)")
                    }
                }
            }
        task.resume()
        }
    }

