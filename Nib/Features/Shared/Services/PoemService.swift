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
    
    private func getPoemDocument(poemId: String) -> DocumentReference {
        poemsCollection.document(poemId)
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
}
