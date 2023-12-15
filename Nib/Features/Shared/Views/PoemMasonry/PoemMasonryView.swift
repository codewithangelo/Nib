//
//  PoemMasonryView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-14.
//

import SwiftUI

struct PoemMasonryView: View {    
    let minCardHeight: CGFloat = 100
    let maxCardHeight: CGFloat = 500
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: PoemMasonryViewModel = PoemMasonryViewModel(poemService: poemService)
    
    let authorId: String?
    let onPoemTap: (Poem) -> Void
    
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
                        .onTapGesture { onPoemTap(poem) }
                },
                loadMore: loadPoems,
                getHeight: getPoemCardHeight
            )
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
        Task {
            do {
                try await viewModel.loadPoems(authorId: authorId)
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
    PoemMasonryView(
        authorId: "fcS7UCJgJ3aTv2VqVGIuyTQF1jw1",
        onPoemTap: { poem in }
    )
}
