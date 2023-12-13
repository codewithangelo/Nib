//
//  DraftViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

@MainActor
final class DraftViewModel: ObservableObject {
    @Published
    var title: String = ""
    
    @Published
    var content: String = ""
    
    private let poemService: PoemServiceProtocol
    
    init(poemService: PoemServiceProtocol) {
        self.poemService = poemService
    }
    
    func publishPoem(user: User) async throws {
        let newPoem = Poem(authorId: user.userId, content: content, title: title)
        try await poemService.createPoem(poem: newPoem)
    }
    
    func reset() {
        self.title = ""
        self.content = ""
    }
}
