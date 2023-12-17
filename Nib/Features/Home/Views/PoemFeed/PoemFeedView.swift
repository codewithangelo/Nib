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
    
    let authorId: String?
    var hasVisitAuthorMenuButton: Bool = false
    
    var body: some View {
        PoemMasonryView(
            authorId: authorId,
            onPoemTap: { poem in
                viewModel.selectedPoem = poem
            },
            emptyView: {
                goToPublisherPrompt
            }
        )
        .navigationDestination(item: $viewModel.selectedPoem) { poem in
            UserPoemView(
                poem: poem,
                hasVisitAuthorMenuButton: hasVisitAuthorMenuButton
            )
        }
    }
}

extension PoemFeedView {
    private var goToPublisherPrompt: some View {
        Button(
            action: { appMain.tabSelection = .publisher },
            label: { Text("feed.emptyState.prompt").monospaced() }
        )
    }
}

#Preview {
    PoemFeedView(authorId: nil)
}
