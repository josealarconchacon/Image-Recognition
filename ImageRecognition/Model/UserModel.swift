//
//  UserModel.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 3/4/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class UserModel {
    private static let filename = "Recognition.plist"
    private static var userDetail = [User]()
    
    static func getUser() -> [User] {
        // FileManager
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    userDetail = try PropertyListDecoder().decode([User].self, from: data)
                } catch {
                    print("property list decoding error: \(error)")
                }
            } else {
                print("data is nil")
            }
        } else {
            print("\(filename) does not exist")
        }
        userDetail = userDetail.sorted { $0.date > $1.date }
        return userDetail
    }
    
    static func addItem(item: User) {
        userDetail.append(item)
        save()
    }
    
    static func delete(user: User, atIndex index: Int) {
        userDetail.remove(at: index)
        save()
    }
    
    static func save() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(userDetail)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoding error: \(error)")
        }
    }
    
    static func updateItem(updatedUser: User, atIndex index: Int) {
        userDetail[index] = updatedUser
        save()
    }
}
