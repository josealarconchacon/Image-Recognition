//
//   AddFaceToFaceList.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 3/5/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class AddFaceToFaceList {
    
    static func addFace(imageURL: String, completionHandler: @escaping ((String?) -> Void)) {
        let endpointURLString = "https://eastus.api.cognitive.microsoft.com/face/v1.0/facelists/newprojectfacelist/persistedFaces"
        guard let url = URL(string: endpointURLString) else {
            print("Bad URL")
            return
        }
     var request = URLRequest(url: url)
         request.addValue("2a4cfb8a6038416ab369fcecd73ab423", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpMethod = "POST"
        
     let newFace = RequestFace.init(persistedFaceId: String())
        do {
             let data = try JSONEncoder().encode(newFace)
             request.httpBody = data
        } catch {
             print("json encoding error: \(error)")
        }
        let task = URLSession.shared.uploadTask(with: request, from: nil) { (data, response, error) in
            if let error = error {
                print("upload task error:  \(error)")
            } else if let data = data {
                print("data: \(data)")
                print(response)
                do {
                    let data = try JSONDecoder().decode(RequestFace.self, from: data)
                    let imageData = data
                    completionHandler(imageData.persistedFaceId)
                    
                } catch {
                    print("decoding error: \(error)")
                }
            }
        }
        task.resume()
    }
}
