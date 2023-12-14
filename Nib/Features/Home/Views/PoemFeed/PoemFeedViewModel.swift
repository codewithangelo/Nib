//
//  PoemFeedViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import FirebaseFirestore
import Foundation

@MainActor
final class PoemFeedViewModel: ObservableObject {
    @Published
    var selectedPoem: Poem? = nil
    
    @Published
    var isFavorite: Bool = false
    
    @Published
    var poems: [Poem] = []
    
    private var lastDocument: DocumentSnapshot? = nil
    private var hasMore: Bool = true
    private let limit = 5
    
    private var poemService: PoemServiceProtocol
    
    init(poemService: PoemServiceProtocol) {
        self.poemService = poemService
    }
    
    func loadPoems() async throws {
        guard hasMore else {
            return
        }
        
        let (poems, lastDocument) = try await poemService.getPoems(
            count: limit,
            lastDocument: lastDocument
        )

        self.poems.append(contentsOf: poems)
        self.lastDocument = lastDocument
        self.hasMore = poems.count >= limit
    }
    
    func reset() {
        self.poems = []
        self.lastDocument = nil
        self.hasMore = true
    }
    
    func loadIsPoemUserFavorite(userId: String) async throws {
        guard let poem = self.selectedPoem, let poemId = poem.id else {
            // TODO: Throw error
            return
        }
        
        let favoritePoem = try? await poemService.getPoemFromUserFavorites(userId: userId, poemId: poemId)
        self.isFavorite = favoritePoem != nil
    }
    
    func addSelectedPoemToUserFavorites(userId: String) async throws {
        guard let poem = self.selectedPoem else {
            // TODO: Throw error
            return
        }
        
        try await poemService.addPoemToUserFavorites(userId: userId, poem: poem)
        self.isFavorite = true
    }
    
    func removeSelectedPoemFromUserFavorites(userId: String) async throws {
        guard let poem = self.selectedPoem else {
            // TODO: Throw error
            return
        }
        
        try await poemService.deletePoemFromUserFavorites(userId: userId, poem: poem)
        self.isFavorite = false
    }
}
