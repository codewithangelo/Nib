//
//  PoemFeedView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct PoemFeedView: View {
    @EnvironmentObject
    var app: AppRootViewModel
    
    let minCardHeight: CGFloat = 100
    let maxCardHeight: CGFloat = 500
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: PoemFeedViewModel = PoemFeedViewModel(poemService: poemService)
    
    @State
    private var showReportPoemView: Bool = false
    
    var body: some View {
        NavigationStack {
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
                            .onTapGesture {
                                viewModel.selectedPoem = poem
                            }
                    },
                    loadMore: loadPoems,
                    getHeight: getPoemCardHeight
                )
            }
            .onAppear {
                refreshPoems()
                viewModel.isFavorite = false
            }
            .refreshable { refreshPoems() }
            .navigationDestination(item: $viewModel.selectedPoem) { poem in
                UserPoemView(poem: poem)
                    .toolbar(content: poemToolbar)
                    .sheet(isPresented: $showReportPoemView) {
                        ReportPoemView(
                            poem: poem,
                            onReportCompleted: { showReportPoemView = false }
                        )
                            .presentationDetents([.medium, .large])
                    }
                    .onAppear(perform: loadIsPoemFavorite)
            }
        }
    }
}

extension PoemFeedView {
    @ToolbarContentBuilder
    private func poemToolbar() -> some ToolbarContent {
        ToolbarItem {
            Button(
                action: { viewModel.isFavorite ? removePoemFromFavorites() : addPoemToFavorites() },
                label: { viewModel.isFavorite ? Image(systemName: "bookmark.fill") : Image(systemName: "bookmark") }
            )
        }
        
        ToolbarItem {
            Menu {
                Button(
                    role: .destructive,
                    action: { showReportPoemView = true },
                    label: { Text("Report") }
                )
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}

extension PoemFeedView {
    private func getPoemCardHeight(poem: Poem) -> CGFloat {
        min(minCardHeight + CGFloat(poem.content.count), maxCardHeight)
    }
}

extension PoemFeedView {
    private func loadPoems() {
        Task {
            do {
                try await viewModel.loadPoems()
            } catch {
                print(error)
            }
        }
    }
    
    private func refreshPoems() {
        viewModel.reset()
        loadPoems()
    }
    
    private func loadIsPoemFavorite() {
        guard let currentUser = app.currentUser else {
            // TODO: Throw error
            return
        }
        Task {
            do {
                try await viewModel.loadIsPoemUserFavorite(userId: currentUser.userId)
            } catch {
                print(error)
            }
        }
    }
    
    private func addPoemToFavorites() {
        guard let currentUser = app.currentUser else {
            // TODO: Throw error
            print("addPoem error")
            return
        }
        print("addPoem")
        Task {
            do {
                try await viewModel.addSelectedPoemToUserFavorites(userId: currentUser.userId)
            } catch {
                print(error)
            }
        }
    }
    
    private func removePoemFromFavorites() {
        guard let currentUser = app.currentUser else {
            // TODO: Throw error
            print("removePoem error")
            return
        }
        print("removePoem")
        Task {
            do {
                try await viewModel.removeSelectedPoemFromUserFavorites(userId: currentUser.userId)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    PoemFeedView()
}
