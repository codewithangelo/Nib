//
//  PoemViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

@MainActor
final class UserPoemViewModel: ObservableObject {
    enum UserPoemViewModelError: LocalizedError {
        case unableToGetPoemAuthor
        
        var errorDescription: String? {
            switch self {
            case .unableToGetPoemAuthor:
                return NSLocalizedString("app.main.unableToGetCurrentUser", comment: "")
            }
        }
    }
    
    enum State: Equatable {
        case unset
        case loading
        case error(error: String?)
        case success(author: Username)
    }
    
    @Published
    var state: State = .unset
    
    private let poemService: PoemServiceProtocol
    
    init(poemService: PoemServiceProtocol) {
        self.poemService = poemService
    }
    
    func loadAuthorName(poem: Poem) async throws {
        do {
            self.state = .loading
            guard let authorName = try? await poemService.getPoemAuthorName(authorId: poem.authorId) else {
                throw UserPoemViewModelError.unableToGetPoemAuthor
            }
            self.state = .success(author: authorName)
        } catch {
            self.state = .error(error: UserPoemViewModelError.unableToGetPoemAuthor.errorDescription)
            throw UserPoemViewModelError.unableToGetPoemAuthor
        }
    }
}
