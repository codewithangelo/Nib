//
//  FavoritePoemServiceProtcol.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-21.
//

import FirebaseFirestore
import Foundation

protocol FavoritePoemServiceProtocol {
    func addPoemToUserFavorites(poem: Poem, userId: String) async throws
    
    func removePoemFromUserFavorites(poem: Poem, userId: String) async throws
    
    func getPoemFromUserFavorites(poemId: String, userId: String) async throws -> FavoritePoem?
    
    func getUserFavoritePoems(count: Int, lastDocument: DocumentSnapshot?, userId: String) async throws -> (documents: [Poem], lastDocument: DocumentSnapshot?) 
}
