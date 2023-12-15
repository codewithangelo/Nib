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
    
    private var poemService: PoemServiceProtocol
    
    init(poemService: PoemServiceProtocol) {
        self.poemService = poemService
    }

    
    func deleteSelectedPoem() async throws {
        guard let poem = selectedPoem, let poemId = poem.id else {
            // TODO: Throw error
            return
        }
        
        try await poemService.deletePoem(poemId: poemId)
        
        selectedPoem = nil
    }
}
