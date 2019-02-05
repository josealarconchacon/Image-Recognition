//
//  ConfidenceData.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/5/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation
struct ConfidenceData: Codable {
    let persistedFaceId: String
    let confidence: Double
}
