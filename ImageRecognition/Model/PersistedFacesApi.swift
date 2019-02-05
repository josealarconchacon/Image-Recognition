//
//  PersistedFacesApi.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/17/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation
import UIKit

/*
 static func getCity(selectedCity: String,completionHandler: @escaping((AppError?, [CityImages.HitWrapper]?) -> Void)) {
 let city = selectedCity.replacingOccurrences(of: " " , with: "+")
 let endpointURLString = "https://pixabay.com/api/?key=\(SecretKeys.CityAPIKey)&q=\(city)&image_type=photo"
 
 guard let url = URL(string: endpointURLString) else {
 completionHandler(AppError.badURL(endpointURLString),nil)
 return
 }
 let request = URLRequest(url: url)
 URLSession.shared.dataTask(with: request) { (data, response, error) in
 if let error = error {
 completionHandler(AppError.networkError(error), nil)
 }
 guard let httpResponse = response as? HTTPURLResponse,
 (200...299).contains(httpResponse.statusCode) else {
 let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
 completionHandler(AppError.badStatusCode("\(statusCode)"), nil)
 return
 }
 if let data = data {
 do {
 let data = try JSONDecoder().decode(CityImages.self, from: data)
 completionHandler(nil,data.hits)
 } catch {
 completionHandler(AppError.jsonDecodingError(error),nil)
 }
 }
 }.resume()
 }
 }
final class PersistedFacesApi {
    private init() {}
     static let face = PersistedFacesApi()
    
    static func detectFace(selecedFace: String,completionHandler: @escaping((AppError?, PersistedFaces?) -> Void)) {
        let endpointURLString = "https://eastus.api.cognitive.microsoft.com/face/v1.0/facelists/josesfirstfacelist99\(SecretKeys.APIKey)"
        guard let url = URL(string: endpointURLString) else {
            completionHandler(AppError.badURL(endpointURLString),nil)
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(AppError.networkError(error), nil)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                    completionHandler(AppError.badStatusCode("\(statusCode)"), nil)
                    return
            }
            if let data = data {
                do {
                    let data = try JSONDecoder().decode(PersistedFaces.self, from: data)
                    completionHandler(nil,data)
                } catch {
                    completionHandler(AppError.jsonDecodingError(error),nil)
                }
            }
        }.resume()
    }
}
*/
