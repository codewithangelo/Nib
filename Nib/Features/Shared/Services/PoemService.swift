//
//  PoemService.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import FirebaseFirestore
import Foundation

final class PoemService: PoemServiceProtocol {
    private enum PoemError: LocalizedError {
        case poemIdRequiredForUpdate
        
        var errorDescription: String? {
            switch self {
            case .poemIdRequiredForUpdate:
                return "Poem ID is required to save changes"
            }
        }
    }
    
    private let poemsCollection = Firestore.firestore().collection("poems")
    private let usersCollection = Firestore.firestore().collection("users")
    private let usernamesCollection = Firestore.firestore().collection("usernames")
    
    private func getUserFavoritePoemsCollection(userId: String) -> CollectionReference {
        getUserDocument(userId: userId).collection("favorites")
    }
    
    private func getPoemDocument(poemId: String) -> DocumentReference {
        poemsCollection.document(poemId)
    }
    
    private func getUserDocument(userId: String) -> DocumentReference {
        usersCollection.document(userId)
    }
    
    private func getUserFavoritePoemDocument(userId: String, poemId: String) -> DocumentReference {
        getUserFavoritePoemsCollection(userId: userId).document(poemId)
    }
    
    private func getUsernameDocument(username: String) -> DocumentReference {
        usernamesCollection.document(username)
    }
    
    func createPoem(poem: Poem) throws {
        let newDocument = poemsCollection.document()
        let poemId = newDocument.documentID
        let newPoem = Poem(
            authorId: poem.authorId,
            content: poem.content,
            createdAt: poem.createdAt,
            id: poemId,
            modifiedAt: poem.modifiedAt,
            title: poem.title
        )
        try getPoemDocument(poemId: poemId).setData(from: newPoem)
    }
    
    func updatePoem(poem: Poem) async throws {
        guard let poemId = poem.id else {
            // TODO: Throw error
            throw PoemError.poemIdRequiredForUpdate
        }
        
        try getPoemDocument(poemId: poemId).setData(from: poem, merge: false)
    }
    
    func getPoem(poemId: String) async throws -> Poem? {
        try await getPoemDocument(poemId: poemId).getDocument(as: Poem.self)
    }
    
    func deletePoem(poemId: String) async throws {
        let poem = getPoemDocument(poemId: poemId)
        try await poem.delete()
    }
    
    func getPoems(count: Int, lastDocument: DocumentSnapshot?) async throws -> (poems: [Poem], lastDocument: DocumentSnapshot?) {
        return try await poemsCollection
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Poem.self)
    }
    
    func getPoemsByAuthorId(authorId: String, count: Int, lastDocument: DocumentSnapshot?) async throws -> (poems: [Poem], lastDocument: DocumentSnapshot?) {
        let query = getPoemsByAuthorQuery(authorId: authorId)
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Poem.self)
    }
    
    private func getPoemsByAuthorQuery(authorId: String) -> Query {
        poemsCollection
            .whereField(Poem.CodingKeys.authorId.rawValue, isEqualTo: authorId)
    }
    
    func getPoemAuthorName(authorId: String) async throws -> Username? {
        try await usernamesCollection.whereField(Username.CodingKeys.userId.rawValue, isEqualTo: authorId).getDocuments(as: Username.self).first
    }
}

// MARK: User Favorite Poems
extension PoemService {
    func getPoemFromUserFavorites(userId: String, poemId: String) async throws -> Poem? {
        let poem = getUserFavoritePoemDocument(userId: userId, poemId: poemId)
        return try await poem.getDocument(as: Poem.self)
    }
    
    func addPoemToUserFavorites(userId: String, poem: Poem) async throws {
        try getUserFavoritePoemDocument(userId: userId, poemId: poem.id!).setData(from: poem, merge: false)
    }
    
    func deletePoemFromUserFavorites(userId: String, poem: Poem) async throws {
        try await getUserFavoritePoemDocument(userId: userId, poemId: poem.id!).delete()
    }
    
    func getUserFavoritePoems(userId: String, count: Int, lastDocument: DocumentSnapshot?) async throws -> (poems: [Poem], lastDocument: DocumentSnapshot?) {
        return try await getUserFavoritePoemsCollection(userId: userId)
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Poem.self)
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).poems
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (poems: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let poems = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (poems, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
}
