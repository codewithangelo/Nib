//
//  PoemFeedView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct PoemFeedView: View {
    let minCardHeight: CGFloat = 100
    let maxCardHeight: CGFloat = 500
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: PoemFeedViewModel = PoemFeedViewModel(poemService: poemService)
    
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
                            .onTapGesture { viewModel.selectedPoem = poem }
                    },
                    loadMore: loadPoems,
                    getHeight: getPoemCardHeight
                )
            }
            .onAppear(perform: loadPoems)
            .refreshable { refreshPoems() }
            .navigationDestination(item: $viewModel.selectedPoem) { poem in
                UserPoemView(poem: poem)
                    .toolbar(content: poemToolbar)
            }
        }
    }
}

extension PoemFeedView {
    @ToolbarContentBuilder
    private func poemToolbar() -> some ToolbarContent {
        ToolbarItem {
            Menu {
                Button(
                    role: .destructive,
                    action: { },
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
}

#Preview {
    PoemFeedView()
}
