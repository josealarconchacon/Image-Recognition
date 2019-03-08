//
//  FaceDetectAPIClient.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/6/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation



final class FaceDetectAPIClient {
  
    
    static func fetchImageFaceUrl(urlInput: URL, completionHandler: @escaping ((DetectFaceResponse) -> Void)) {
        let endpointURLString = "https://eastus.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false"
        guard let url = URL(string: endpointURLString) else {
            print("Bad url")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("2a4cfb8a6038416ab369fcecd73ab423", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let newFaceInfo = DetectFaceUrl.init(url: urlInput)
        do {
            let data = try JSONEncoder().encode(newFaceInfo)
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
                    let data = try JSONDecoder().decode([DetectFaceResponse].self, from: data)
                    guard let dataUnwrapped = data.first else {return}
                        completionHandler(dataUnwrapped)
                    
                } catch {
                    print("decoding error: \(error)")
                }
            }
        }
        task.resume()
    }
    
}

