//
//  ImageBox.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/18/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

struct ImageBox: Codable {
    let fileName: String
    init(fileName: String) {
        self.fileName = fileName
    }
    init(dictionary:[String: Any]) {
        self.fileName = dictionary["fileName"] as? String ?? "not file name"
    }
}
