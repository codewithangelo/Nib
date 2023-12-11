//
//  UserService.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import FirebaseFirestore
import Foundation

final class UserService: UserServiceProtocol {
    private let usersCollection = Firestore.firestore().collection("users")
    private let usernamesCollection = Firestore.firestore().collection("usernames")
    
    private func getUserDocument(userId: String) -> DocumentReference {
        usersCollection.document(userId)
    }
    
    private func getUsernameDocument(username: String) -> DocumentReference {
        usernamesCollection.document(username)
    }
}

// MARK: USER
extension UserService {
    func createNewUser(user: User) async throws {
        let batch = Firestore.firestore().batch()
        
        let userDocRef = getUserDocument(userId: user.userId)
        try batch.setData(from: user, forDocument: userDocRef, merge: false)
        
        if let displayName = user.displayName, !displayName.isEmpty {
            let usernameDocRef = getUsernameDocument(username: displayName)
            let username = Username(userId: user.userId, username: displayName)
            try batch.setData(from: username, forDocument: usernameDocRef, merge: false)
        }
        
        try await batch.commit()
    }
    
    func getUser(userId: String) async throws -> User? {
        try await getUserDocument(userId: userId).getDocument(as: User.self)
    }
    
    func deleteUser(user: User) async throws {
        let batch = Firestore.firestore().batch()
        
        let userDocRef = getUserDocument(userId: user.userId)
        batch.deleteDocument(userDocRef)
        
        if let displayName = user.displayName, !displayName.isEmpty {
            let usernameDocRef = getUsernameDocument(username: displayName)
            batch.deleteDocument(usernameDocRef)
        }
        
        try await batch.commit()
    }
}
