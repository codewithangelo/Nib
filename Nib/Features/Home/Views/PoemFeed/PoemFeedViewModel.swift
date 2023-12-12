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
}
