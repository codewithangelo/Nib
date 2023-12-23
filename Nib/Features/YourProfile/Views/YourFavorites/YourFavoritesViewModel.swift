//
//  YourFavoritesViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-21.
//

import FirebaseFirestore
import Foundation

@MainActor
final class YourFavoritesViewModel: ObservableObject {
    @Published
    var selectedPoem: Poem? = nil
    
    @Published
    var poems: [Poem] = []
    
    @Published
    var hasMore: Bool = true
    private var lastDocument: DocumentSnapshot? = nil
    private let limit = 5
    
    private var favoritePoemService: FavoritePoemServiceProtocol
    
    init(favoritePoemService: FavoritePoemServiceProtocol) {
        self.favoritePoemService = favoritePoemService
    }
    
    func loadPoems(userId: String) async throws {
        guard hasMore else {
            return
        }

        let (poems, lastDocument) = try await favoritePoemService.getUserFavoritePoems(
            count: limit,
            lastDocument: lastDocument,
            userId: userId
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
}
