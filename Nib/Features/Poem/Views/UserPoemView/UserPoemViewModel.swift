//
//  PoemViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

@MainActor
final class UserPoemViewModel: ObservableObject {
    public enum State: Equatable {
        case loading
        case error
        case success(author: Username)
    }
    
    @Published
    var state: State = .loading
    
    private let poemService: PoemServiceProtocol
    
    init(poemService: PoemServiceProtocol) {
        self.poemService = poemService
    }
    
    func loadAuthorName(poem: Poem) async {
        do {
            guard let authorName = try await poemService.getPoemAuthorName(authorId: poem.authorId) else {
                self.state = .error
                // TODO: Throw error
                return
            }
            self.state = .success(author: authorName)
        } catch {
            self.state = .error
        }
    }
}
