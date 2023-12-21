//
//  LikeButtonViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-20.
//

import Foundation

@MainActor
final class LikeButtonViewModel: ObservableObject {
    enum LikeButtonViewModelError: LocalizedError {
        case unableToLikePoem
        case unableToUnlikePoem
        
        var errorDescription: String? {
            switch self {
            case .unableToLikePoem:
                return NSLocalizedString("poem.like.error", comment: "")
            case .unableToUnlikePoem:
                return NSLocalizedString("poem.unlike.error", comment: "")
            }
        }
    }
    
    @Published
    var liked: Bool = false
    
    @Published
    var likeCount: Int = 0
    
    private let likeService: LikeServiceProtocol
    
    init(likeService: LikeServiceProtocol) {
        self.likeService = likeService
    }
    
    func loadHasUserLikedPoem(poemId: String, user: User) async throws {
        self.liked = try await likeService.getHasUserLikedPoem(poemId: poemId, user: user)
    }
    
    func loadPoemLikeCount(poemId: String) async throws {
        self.likeCount = try await likeService.getPoemLikeCount(poemId: poemId)
    }
    
    func likePoem(poemId: String, user: User) async throws {
        try await likeService.likePoem(poemId: poemId, user: user)
        self.liked = true
        self.likeCount += 1
    }
    
    func unlikePoem(poemId: String, user: User) async throws {
        try await likeService.unlikePoem(poemId: poemId, user: user)
        self.liked = false
        self.likeCount -= 1
    }
}
