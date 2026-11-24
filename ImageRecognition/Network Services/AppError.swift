//
//  AppError.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 1/24/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation
enum AppError: Error {
    case badURL(String)
    case networkError(Error)
    case badStatusCode(String)
    case jsonEncodingError(Error)
    case jsonDecodingError(Error)
    case noData
    case noFaceDetected

    public func errorMessage() -> String {
        switch self {
        case .badURL(let message):
            return "bad url: \(message)"
        case .networkError(let error):
            return "network error: \(error.localizedDescription)"
        case .badStatusCode(let message):
            return "bad status code: \(message)"
        case .jsonEncodingError(let error):
            return "encoding error: \(error)"
        case .jsonDecodingError(let error):
            return "decoding error: \(error)"
        case .noData:
            return "the server returned no data"
        case .noFaceDetected:
            return "No face was found in this photo. Please try a clearer photo of one face."
        }
    }
}
