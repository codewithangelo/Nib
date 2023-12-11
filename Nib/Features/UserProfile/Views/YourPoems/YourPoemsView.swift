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
    
    @State
    private var selectedPoem: Poem? = nil
    
    var body: some View {
        ScrollView {
            Masonry(
                gridItems: viewModel.poems,
                numOfColumns: 2,
                itemContent: { poem in
                    Card(title: poem.title, content: poem.content)
                        .frame(
                            minHeight: minCardHeight,
                            idealHeight: getPoemCardHeight(poem: poem),
                            maxHeight: maxCardHeight
                        )
                        .onTapGesture { selectedPoem = poem }
                },
                loadMore: loadPoems,
                getHeight: getPoemCardHeight
            )
        }
        .onAppear(perform: loadPoems)
        .refreshable { refreshPoems() }
        .sheet(item: $selectedPoem) { poem in
            VStack {
                poemSheetHeader
                PoemView(poem: poem)
            }
        }
    }
}

extension YourPoemsView {
    private var poemSheetHeader: some View {
        HStack {
            Spacer()
            Button(
                action: { selectedPoem = nil },
                label: {
                    Image(systemName: "xmark")
                }
            )
        }
        .padding()
    }
}

extension YourPoemsView {
    private func getPoemCardHeight(poem: Poem) -> CGFloat {
        min(minCardHeight + CGFloat(poem.content.count), maxCardHeight)
    }
}

extension YourPoemsView {
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
