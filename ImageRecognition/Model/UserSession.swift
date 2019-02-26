//
//  UserSession.swift
//  ImageRecognition
//
//  Created by Jose Alarcon Chacon on 2/25/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import Foundation
import  FirebaseAuth

protocol UserAccountCreationDelegate: AnyObject {
    func didCreateAccount(_ userSession: UserSession, user: User)
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error)
}
protocol UserSessionSignOutDelegate: AnyObject {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error)
    func didSignOutUser(_ usersession: UserSession)
}
protocol UserSessionSignInDelegate: AnyObject {
    func didRecieveSignInError(_ usersession: UserSession, error: Error)
    func didSignInExistingUser(_ usersession: UserSession, user: User)
}

final class UserSession {
    weak var userAccountCreation: UserAccountCreationDelegate?
    weak var userSignOutDelegate: UserSessionSignOutDelegate?
    weak var userSignInDelegate: UserSessionSignInDelegate?
    
    private func newAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                self.userAccountCreation?.didRecieveErrorCreatingAccount(self, error: error)
            } else if let dataResult = dataResult {
                self.userAccountCreation?.didCreateAccount(self, user: dataResult.user)
                guard let username = dataResult.user.email?.components(separatedBy: "@").first else { print("no email entered") ; return  }
                
                DatabaseManager.firebaseDatabase.collection(DetabaseKey.UserCollectionKey).document(dataResult.user.uid.description)
                .setData(["userId" : dataResult.user.uid,
                          "email"  : dataResult.user.email ?? "",
                          "displayName" : dataResult.user.displayName ?? "",
                          "imageURL" : dataResult.user.photoURL ?? "",
                          "username" : username  ], completion: { (error) in
                            if let error = error {
                                print("error adding authenticated user to the database: \(error)")
                            }
                   })
            }
        }
    }
    public func getUser() -> User? {
        return Auth.auth().currentUser
    }
    public func signInExistingUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                self.userSignInDelegate?.didRecieveSignInError(self, error: error)
            } else if let dataResult = dataResult {
                self.userSignInDelegate?.didSignInExistingUser(self, user: dataResult.user)
            }
        }
    }
    public func signOut() {
        guard let _ = getUser() else {
            print("no logged user")
            return
        }
        do{
            try Auth.auth().signOut(); self.userSignOutDelegate?.didSignOutUser(self)
        } catch {
            self.userSignOutDelegate?.didRecieveSignOutError(self, error: error)
        }
    }
    public func updateUser(name: String?, photoURL: URL?) {
        guard let user = getUser() else { print("no logged user"); return  }
        
        let userRequest = user.createProfileChangeRequest()
        userRequest.displayName = name ; userRequest.photoURL = photoURL
        userRequest.commitChanges { (error) in
            if let error = error {
                print("error is \(error.localizedDescription)")
            } else {
                guard let photoURL = photoURL else { print("no photo url available"); return  }
                
                DatabaseManager.firebaseDatabase.collection(DetabaseKey.UserCollectionKey).document(user.uid)
                    .updateData(["imageURL" : photoURL.absoluteString], completion: { (error) in
                        guard let error = error else { print("successfully"); return}
                        
                        print("updating photo url error: \(error.localizedDescription)")
                    })
            }
        }
    }
}
