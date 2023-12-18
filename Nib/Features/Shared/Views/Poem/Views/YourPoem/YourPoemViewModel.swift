//
//  YourPoemViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-17.
//

import Foundation

@MainActor
final class YourPoemViewModel: ObservableObject {
    private var poemService: PoemServiceProtocol
    
    init(poemService: PoemServiceProtocol) {
        self.poemService = poemService
    }
    
    
    func deletePoem(poem: Poem) async throws {
        guard let poemId = poem.id else {
            // TODO: Throw error
            return
        }
        
        try await poemService.deletePoem(poemId: poemId)
    }
}
