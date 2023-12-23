//
//  PoemMasonryView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-14.
//

import SwiftUI

struct PoemMasonryView<Content: View>: View {
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    let minCardHeight: CGFloat = 100
    let maxCardHeight: CGFloat = 500
    
    @StateObject
    private var viewModel: PoemMasonryViewModel = PoemMasonryViewModel(poemService: PoemService())
    
    let authorId: String?
    let onPoemTap: (Poem) -> Void
    let emptyView: () -> Content
    
    var body: some View {
        VStack {
            if !viewModel.hasMore && viewModel.poems.isEmpty {
                VStack {
                    Spacer()
                    emptyView()
                    Spacer()
                }
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
                                .onTapGesture { onPoemTap(poem) }
                        },
                        loadMore: loadPoems,
                        getHeight: getPoemCardHeight
                    )
                }
            }
        }
        .onAppear(perform: refreshPoems)
        .refreshable { refreshPoems() }
    }
}

extension PoemMasonryView {
    private func getPoemCardHeight(poem: Poem) -> CGFloat {
        min(minCardHeight + CGFloat(poem.content.count), maxCardHeight)
    }
}

extension PoemMasonryView {
    private func loadPoems() {
        guard !appRoot.showSignInView else {
            return
        }
        
        Task {
            do {
                try await viewModel.loadPoems(authorId: authorId)
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
    PoemMasonryView(
        authorId: "123",
        onPoemTap: { poem in },
        emptyView: { Text("Empty") }
    )
}
