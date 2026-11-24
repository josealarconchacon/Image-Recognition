//
//  NetworkHelper.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/16/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class NetworkHelper {
    private init() {}
    static let shared = NetworkHelper()
    func performDataTask(endpointURLString: String,
                         httpMethod: String,
                         httpBody: Data?,
                         handler: @escaping (AppError?, Data?) -> Void) {
        guard let url = URL(string: endpointURLString) else {
            handler(AppError.badURL(endpointURLString), nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                handler(AppError.networkError(error), nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                    handler(AppError.badStatusCode(String(statusCode)), nil)
                    return
            }
            guard let data = data else {
                handler(AppError.noData, nil)
                return
            }
            handler(nil, data)
        }
        task.resume()
    }
}

/// Shared client for the Azure Face API. Every call reports exactly once,
/// on the main queue, with either a decoded response or an AppError.
enum FaceAPI {
    static let baseURL = "https://eastus.api.cognitive.microsoft.com/face/v1.0"

    static func post<Body: Encodable, Response: Decodable>(path: String,
                                                           body: Body,
                                                           completion: @escaping (Result<Response, AppError>) -> Void) {
        func finish(_ result: Result<Response, AppError>) {
            DispatchQueue.main.async { completion(result) }
        }
        guard let url = URL(string: baseURL + path) else {
            finish(.failure(.badURL(baseURL + path)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(SecretKeys.faceAPIKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            finish(.failure(.jsonEncodingError(error)))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                finish(.failure(.networkError(error)))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
                !(200...299).contains(httpResponse.statusCode) {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                finish(.failure(.badStatusCode("\(httpResponse.statusCode) \(body)")))
                return
            }
            guard let data = data else {
                finish(.failure(.noData))
                return
            }
            do {
                finish(.success(try JSONDecoder().decode(Response.self, from: data)))
            } catch {
                finish(.failure(.jsonDecodingError(error)))
            }
        }.resume()
    }
}
