//
//  YourPoemsViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import FirebaseFirestore
import Foundation

@MainActor
final class YourPoemsViewModel: ObservableObject {
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
    
    func loadPoemsByCurrentUser(userId: String) async throws {
        guard hasMore else {
            return
        }
        
//        print("BEFORE FETCHING POEMS BY AUTHOR")
//        print(hasMore)
//        print(poems)
        
        let (poems, lastDocument) = try await poemService.getPoemsByAuthorId(
            authorId: userId,
            count: limit,
            lastDocument: lastDocument
        )
//        print(hasMore)
//        print(poems)
//        print("AFTER FETCHING POEMS BY AUTHOR")
        self.poems.append(contentsOf: poems)
        self.lastDocument = lastDocument
        self.hasMore = poems.count >= limit
    }
    
    func reset() {
        self.poems = []
        self.lastDocument = nil
        self.hasMore = true
    }
    
    func deletePoem() async throws {
        guard let poem = selectedPoem, let poemId = poem.id else {
            // TODO: Throw error
            return
        }
        
        try await poemService.deletePoem(poemId: poemId)
        
        selectedPoem = nil
    }
}
