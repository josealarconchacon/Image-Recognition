//
//  IRUser.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/22/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

struct IRUser {
    let username: String?
    let imageURL: String?

    init(dict: [String: Any]) {
        self.username = dict["username"] as? String ?? "no username"
         self.imageURL = dict["imageURL"] as? String ?? "no imageURL"
    }
}
