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
    private let usernamesCollection = Firestore.firestore().collection("usernames")
    private let favoritesCollection = Firestore.firestore().collection("favorites")
    
    private func getPoemDocument(poemId: String) -> DocumentReference {
        poemsCollection.document(poemId)
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
            createdAt: Date(),
            id: poemId,
            modifiedAt: Date(),
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
        let favoritePoemDocs = try await favoritesCollection
            .whereField(FavoritePoem.CodingKeys.poemId.rawValue, isEqualTo: poemId)
            .getDocuments()
        
        let batch = Firestore.firestore().batch()
        
        let poemDocRef = getPoemDocument(poemId: poemId)
        
        batch.deleteDocument(poemDocRef)
        
        for favoritePoemDoc in favoritePoemDocs.documents {
            batch.deleteDocument(favoritePoemDoc.reference)
        }
        
        try await batch.commit()
    }
    
    func getPoems(count: Int, lastDocument: DocumentSnapshot?, authorId: String? = nil) async throws -> (documents: [Poem], lastDocument: DocumentSnapshot?) {
        var query: Query = getAllPoemsQuery()
        
        if let authorId {
            query = getPoemsByAuthorQuery(authorId: authorId)
        }
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Poem.self)
    }
    
    private func getPoemsByAuthorQuery(authorId: String) -> Query {
        poemsCollection
            .whereField(Poem.CodingKeys.authorId.rawValue, isEqualTo: authorId)
            .order(by: Poem.CodingKeys.createdAt.rawValue, descending: false)
    }
    
    private func getAllPoemsQuery() -> Query {
        poemsCollection
            .order(by: Poem.CodingKeys.createdAt.rawValue, descending: false)
    }
    
    func getPoemAuthorName(authorId: String) async throws -> Username? {
        try await usernamesCollection.whereField(Username.CodingKeys.userId.rawValue, isEqualTo: authorId).getDocuments(as: Username.self).first
    }
}
