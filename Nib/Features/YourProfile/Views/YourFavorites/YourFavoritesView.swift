//
//  YourFavoritesView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-21.
//

import SwiftUI

struct YourFavoritesView: View {
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    let minCardHeight: CGFloat = 100
    let maxCardHeight: CGFloat = 500
    
    private static let favoritePoemService: FavoritePoemServiceProtocol = FavoritePoemService()
    
    @StateObject
    private var viewModel: YourFavoritesViewModel = YourFavoritesViewModel(favoritePoemService: favoritePoemService)
    
    var body: some View {
        if !viewModel.hasMore, viewModel.poems.isEmpty {
            Text("favorites.emptyState")
                .monospaced()
            Spacer()
        } else {
            ScrollView {
                Masonry(
                    gridItems: $viewModel.poems,
                    numOfColumns: 2,
                    itemContent: { poem in
                        Card(title: poem.title, content: poem.content)
                            .frame(
                                minHeight: minCardHeight,
                                idealHeight: getPoemCardHeight(poem: poem),
                                maxHeight: maxCardHeight
                            )
                            .onTapGesture { viewModel.selectedPoem = poem }
                    },
                    loadMore: loadPoems,
                    getHeight: getPoemCardHeight
                )
            }
            .onAppear(perform: refreshPoems)
            .refreshable { refreshPoems() }
            .navigationDestination(item: $viewModel.selectedPoem) { poem in
                if let currentUser = appMain.currentUser,
                   currentUser.userId == poem.authorId {
                    YourPoemView(
                        poem: poem,
                        onDeleteCompleted: { viewModel.selectedPoem = nil }
                    )
                } else {
                    UserPoemView(
                        poem: poem,
                        hasVisitAuthorMenuButton: true
                    )
                }
            }
        }
    }
}

extension YourFavoritesView {
    private func getPoemCardHeight(poem: Poem) -> CGFloat {
        min(minCardHeight + CGFloat(poem.content.count), maxCardHeight)
    }
}

extension YourFavoritesView {
    private func loadPoems() {
        guard !appRoot.showSignInView, let currentUser = appMain.currentUser else {
            return
        }
        
        Task {
            do {
                try await viewModel.loadPoems(userId: currentUser.userId)
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("masonry.loadPoems.error", comment: "")
                )
            }
        }
    }
    
    private func refreshPoems() {
        viewModel.reset()
        loadPoems()
    }
}

#Preview {
    YourFavoritesView()
}
