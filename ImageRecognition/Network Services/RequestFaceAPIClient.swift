//
//  RequestFaceAPIClient.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/7/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class RequestFaceAPIClient {
    static func fetchImageFaceUrl(image: String, completionHandler: @escaping ((RequestFace) -> Void)) {
        let endpointURLString = "https://eastus.api.cognitive.microsoft.com/face/v1.0/facelists/allfacesavailable2019/persistedFaces"
        guard let url = URL(string: endpointURLString) else {
            print("Bad url")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("2a4cfb8a6038416ab369fcecd73ab423", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let newFaceInfo = RequestFace.init(persistedFaceId: image)
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
                    let data = try JSONDecoder().decode([RequestFace].self, from: data)
                    guard let imageData = data.first else {return}
                    completionHandler(imageData)
                    
                } catch {
                    print("decoding error: \(error)")
                }
            }
        }
        task.resume()
    }
}
