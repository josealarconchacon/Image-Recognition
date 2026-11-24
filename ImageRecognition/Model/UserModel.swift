//
//  UserModel.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/7/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation

final class UserModel {
    private static let filename = "Recognition.plist"
    // Loaded from disk on first access, so addItem never overwrites saved
    // entries it hasn't read yet. Always kept sorted newest first, so table
    // row indexes match array indexes.
    private static var userDetail: [User] = load()

    private static func load() -> [User] {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        guard let data = FileManager.default.contents(atPath: path) else {
            return []
        }
        do {
            return sortedNewestFirst(try PropertyListDecoder().decode([User].self, from: data))
        } catch {
            print("property list decoding error: \(error)")
            return []
        }
    }

    private static func sortedNewestFirst(_ users: [User]) -> [User] {
        return users.sorted { $0.date > $1.date }
    }

    static func getUser() -> [User] {
        return userDetail
    }

    static func addItem(item: User) {
        userDetail = sortedNewestFirst(userDetail + [item])
        save()
    }

    static func delete(user: User, atIndex index: Int) {
        guard userDetail.indices.contains(index) else { return }
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
        guard userDetail.indices.contains(index) else { return }
        userDetail[index] = updatedUser
        userDetail = sortedNewestFirst(userDetail)
        save()
    }
}
