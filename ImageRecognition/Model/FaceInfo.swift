//
//  FaceInfo.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/5/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation
struct FaceInfo: Codable {
    let faceId: String
    let faceListId: String
    let maxNumOfCandidatesReturned: Int
    let mode: String
    
    /*{
     "faceId": "6f86b393-440a-488c-a4c7-388b9ebb6e54",
     "faceListId": "newprojectfacelist",
     "maxNumOfCandidatesReturned": 1,
     "mode": "matchPerson"
     }
     */
}
