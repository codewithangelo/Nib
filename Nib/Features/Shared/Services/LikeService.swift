//
//  LikeService.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-20.
//

import FirebaseFirestore
import Foundation

final class LikeService: LikeServiceProtocol {
    private let poemsCollection = Firestore.firestore().collection("poems")
    
    private func getPoemDocument(poemId: String) -> DocumentReference {
        poemsCollection.document(poemId)
    }
    
    private func getPoemLikeCollection(poemId: String) -> CollectionReference {
        getPoemDocument(poemId: poemId).collection("likes")
    }
    
    private func getUserDocumentFromPoemLikes(poemId: String, userId: String) -> DocumentReference {
        getPoemLikeCollection(poemId: poemId).document(userId)
    }
    
    func getHasUserLikedPoem(poemId: String, user: User) async throws -> Bool {
        try await getUserDocumentFromPoemLikes(poemId: poemId, userId: user.userId).getDocument().exists
    }
    
    func getPoemLikeCount(poemId: String) async throws -> Int {
        try await getPoemDocument(poemId: poemId).getDocument(as: Poem.self).likeCount ?? 0
    }
    
    func likePoem(poemId: String, user: User) async throws {
        let batch = Firestore.firestore().batch()
        
        let poemDocRef = getPoemDocument(poemId: poemId)
        batch.updateData([
            Poem.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(1))
        ], forDocument: poemDocRef)
        
        let poemLikedByUserDocRef = getUserDocumentFromPoemLikes(poemId: poemId, userId: user.userId)
        try batch.setData(from: user, forDocument: poemLikedByUserDocRef)
        
        try await batch.commit()
    }
    
    func unlikePoem(poemId: String, user: User) async throws {
        let batch = Firestore.firestore().batch()
        
        let poemDocRef = getPoemDocument(poemId: poemId)
        batch.updateData([
            Poem.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(-1))
        ], forDocument: poemDocRef)
        
        let poemLikedByUserDocRef = getUserDocumentFromPoemLikes(poemId: poemId, userId: user.userId)
        batch.deleteDocument(poemLikedByUserDocRef)
        
        try await batch.commit()
    }
    
}
