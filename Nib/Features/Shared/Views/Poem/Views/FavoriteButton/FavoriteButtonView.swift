//
//  FavoriteButtonView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-21.
//

import SwiftUI

struct FavoriteButtonView: View {
    let poem: Poem
    
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    private static let favoritePoemService: FavoritePoemServiceProtocol = FavoritePoemService()
    
    @StateObject
    private var viewModel: FavoriteButtonViewModel = FavoriteButtonViewModel(favoritePoemService: favoritePoemService)
    
    var body: some View {
        Button(
            action: viewModel.isFavorite ? removePoemFromFavorites : addPoemToFavorites,
            label: { Image(systemName: viewModel.isFavorite ? "bookmark.fill" : "bookmark") }
        )
        .onAppear(perform: loadPoemIsFavorite)
    }
}

extension FavoriteButtonView {
    func loadPoemIsFavorite() {
        guard let poemId = poem.id, let currentUser = appMain.currentUser else {
            // Silently erro
            return
        }
        
        Task {
            do {
                try await viewModel.loadIsFavorite(poemId: poemId, userId: currentUser.userId)
            } catch {
                // Silently error
            }
        }
    }
    
    func addPoemToFavorites() {
        guard let currentUser = appMain.currentUser else {
            appRoot.toast = Toast(
                style: .error,
                message: NSLocalizedString("poem.favorite.error", comment: "")
            )
            return
        }
        
        Task {
            do {
                try await viewModel.addPoemToUserFavorites(poem: poem, userId: currentUser.userId)
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("poem.favorite.error", comment: "")
                )
            }
        }
    }
    
    func removePoemFromFavorites() {
        guard let currentUser = appMain.currentUser else {
            appRoot.toast = Toast(
                style: .error,
                message: NSLocalizedString("poem.favorite.error", comment: "")
            )
            return
        }
        
        Task {
            do {
                try await viewModel.removePoemFromUserFavorites(poem: poem, userId: currentUser.userId)
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("poem.favorite.error", comment: "")
                )
            }
        }
    }
}

#Preview {
    FavoriteButtonView(
        poem: Poem(
            authorId: "123",
            content: "Lorem ipsum",
            id: "1",
            title: "Lorem ipsum"
        )
    )
}
