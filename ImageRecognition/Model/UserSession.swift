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

}
