//
//  DatabaseManager.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/18/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation
import  Firebase

final class DatabaseManager {
    private init (){}
    private static let firebaseDatabase = Firestore.firestore()
    
    static func saveImage(fox: ImageBox) {
        firebaseDatabase.collection("imageBoxes").addDocument(data: ["fileName": fox.fileName])
    }
    static func getImage(completion: @escaping(([ImageBox]) -> Void)) { // retriving the imsge
        var finalArray = [ImageBox]()
        // call the database to retrive what is in there
        firebaseDatabase.collection("imageBoxes").addSnapshotListener { (snapshotImage, error) in
            if let snapshotImage = snapshotImage {
                for document in snapshotImage.documents {
                    let image = ImageBox.init(dictionary: document.data())
                    finalArray.append(image)
                }
                completion(finalArray)
            }
        }
    }
}

