//
//  YourPoemsView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct YourPoemsView: View {
    @EnvironmentObject
    var app: AppRootViewModel
    
    let minCardHeight: CGFloat = 100
    let maxCardHeight: CGFloat = 500
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: YourPoemsViewModel = YourPoemsViewModel(poemService: poemService)
    
    var body: some View {
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
        .onAppear(perform: loadPoems)
        .refreshable { refreshPoems() }
        .navigationDestination(item: $viewModel.selectedPoem) { poem in
            PoemView(poem: poem)
                .toolbar(content: poemToolbar)
        }
    }
}

extension YourPoemsView {
    @ToolbarContentBuilder
    private func poemToolbar() -> some ToolbarContent {
        ToolbarItem {
            Menu {
                Button(
                    role: .destructive,
                    action: deleteSelectedPoem,
                    label: { Text("Delete") }
                )
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}

extension YourPoemsView {
    private func getPoemCardHeight(poem: Poem) -> CGFloat {
        min(minCardHeight + CGFloat(poem.content.count), maxCardHeight)
    }
}

extension YourPoemsView {
    private func deleteSelectedPoem() {
        Task {
            do {
                try await viewModel.deleteSelectedPoem()
            } catch {
                print(error)
            }
        }
        refreshPoems()
    }
    
    private func loadPoems() {
        guard let currentUser = app.currentUser else {
            // TODO: Throw error
            return
        }
        
        Task {
            do {
                try await viewModel.loadPoemsByCurrentUser(userId: currentUser.userId)
            } catch {
                print(error)
            }
        }
    }
    
    private func refreshPoems() {
        viewModel.reset()
        loadPoems()
    }
}

#Preview {
    YourPoemsView()
}
