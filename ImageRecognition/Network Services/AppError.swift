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
    case jsonDecodingError(Error)
    public func errorMessage() -> String {
        switch self {
        case .badURL(let message):
            return "bad url: \(message)"
        case .networkError(let error):
            return "network error: \(error)"
        case .badStatusCode(let message):
            return "bad status code: \(message)"
        case .jsonDecodingError(let error):
            return "decoding error: \(error)"
        }
    }
}
