//
//  FavoritePoemService.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-21.
//

import FirebaseFirestore
import Foundation

final class FavoritePoemService: FavoritePoemServiceProtocol {
    private let favoritesCollection = Firestore.firestore().collection("favorites")
    private let poemsCollection = Firestore.firestore().collection("poems")
    
    private func getFavoriteDocument(userId: String, poemId: String) -> DocumentReference {
        favoritesCollection.document("\(userId)\(poemId)")
    }
    
    func addPoemToUserFavorites(poem: Poem, userId: String) async throws {
        guard let poemId = poem.id else {
            return
        }
        
        try getFavoriteDocument(userId: userId, poemId: poemId)
            .setData(from: FavoritePoem(userId: userId, poemId: poemId), merge: false)
    }
    
    func removePoemFromUserFavorites(poem: Poem, userId: String) async throws {
        guard let poemId = poem.id else {
            return
        }
        
        try await getFavoriteDocument(userId: userId, poemId: poemId).delete()
    }
    
    func getPoemFromUserFavorites(poemId: String, userId: String) async throws -> FavoritePoem? {
        try await getFavoriteDocument(userId: userId, poemId: poemId).getDocument(as: FavoritePoem.self)
    }
    
    func getUserFavoritePoems(count: Int, lastDocument: DocumentSnapshot?, userId: String) async throws -> (documents: [Poem], lastDocument: DocumentSnapshot?) {
        let query: Query = getUserFavoritePoemsQuery(userId: userId)
        
        let favorites = try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: FavoritePoem.self)
        
        if favorites.documents.isEmpty {
            return (documents: [], lastDocument: nil)
        }
        
        let poemIds = favorites.documents.map { $0.poemId }
        
        let poems = try await poemsCollection
            .whereField(Poem.CodingKeys.id.rawValue, in: poemIds)
            .limit(to: count)
            .getDocuments(as: Poem.self)
        
        return (documents: poems, lastDocument: favorites.lastDocument)
    }
    
    private func getUserFavoritePoemsQuery(userId: String) -> Query {
        favoritesCollection
            .whereField(FavoritePoem.CodingKeys.userId.rawValue, isEqualTo: userId)
    }
}
