//
//  PoemFeedView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct PoemFeedView: View {
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    @StateObject
    private var viewModel: PoemFeedViewModel = PoemFeedViewModel()
    
    var hasVisitAuthorMenuButton: Bool = false
    
    var body: some View {
        PoemMasonryView(
            authorId: nil,
            onPoemTap: { poem in
                viewModel.selectedPoem = poem
            },
            emptyView: {
                goToPublisherPrompt
            }
        )
        .navigationDestination(item: $viewModel.selectedPoem) { poem in
            if let currentUser = appMain.currentUser,
               currentUser.userId == poem.authorId {
                YourPoemView(
                    poem: poem,
                    onDeleteCompleted: onDeletePoemCompleted
                )
            } else {
                UserPoemView(
                    poem: poem,
                    hasVisitAuthorMenuButton: hasVisitAuthorMenuButton
                )
            }
        }
    }
}

extension PoemFeedView {
    private var goToPublisherPrompt: some View {
        Button(
            action: { appMain.tabSelection = .publisher },
            label: { Text("feed.emptyState.prompt").monospaced() }
        )
        .padding(.horizontal)
    }
    
    private func onDeletePoemCompleted() {
        viewModel.selectedPoem = nil
    }
}

#Preview {
    PoemFeedView()
}
