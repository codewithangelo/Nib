//
//  FavoriteButtonViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-21.
//

import Foundation

@MainActor
final class FavoriteButtonViewModel: ObservableObject {
    enum FavoriteButtonViewModelError: LocalizedError {
        case unableToFavoritePoem
        case unableToUnfavoritePoem
        
        var errorDescription: String? {
            switch self {
            case .unableToFavoritePoem:
                return NSLocalizedString("poem.favorite.error", comment: "")
            case .unableToUnfavoritePoem:
                return NSLocalizedString("poem.unfavorite.error", comment: "")
            }
        }
    }
    
    @Published
    var isFavorite: Bool = false
    
    private let favoritePoemService: FavoritePoemServiceProtocol
    
    init(favoritePoemService: FavoritePoemServiceProtocol) {
        self.favoritePoemService = favoritePoemService
    }
    
    func loadIsFavorite(poemId: String, userId: String) async throws {
        let poem: FavoritePoem? = try? await favoritePoemService.getPoemFromUserFavorites(poemId: poemId, userId: userId)
        self.isFavorite = poem != nil
    }
    
    func addPoemToUserFavorites(poem: Poem, userId: String) async throws {
        try await favoritePoemService.addPoemToUserFavorites(poem: poem, userId: userId)
        self.isFavorite = true
    }
    
    func removePoemFromUserFavorites(poem: Poem, userId: String) async throws {
        try await favoritePoemService.removePoemFromUserFavorites(poem: poem, userId: userId)
        self.isFavorite = false
    }
}
