//
//  User.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 3/4/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation


struct User: Codable, Equatable {
    let name: String
    let lastName: String
    let country: String
    let createdAt: String
    let confidence: Double
    let matchID: String
    let age: String
    let firebaseImageURLString: String

    public var dateFormattedString: String {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = createdAt
        if let date = isoDateFormatter.date(from: createdAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy hh:mm a" // January 11, 2019 3:27pm
            formattedDate = dateFormatter.string(from: date)
        }
        return formattedDate
    }
    public var date: Date {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = Date()
        if let date = isoDateFormatter.date(from: createdAt) {
            formattedDate = date
        }
        return formattedDate
    }
}
