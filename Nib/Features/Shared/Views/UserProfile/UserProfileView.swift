//
//  UserProfileView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-17.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    @StateObject
    private var viewModel: UserProfileViewModel = UserProfileViewModel()
    
    let authorId: String
    
    var body: some View {
        PoemMasonryView(
            authorId: authorId,
            onPoemTap: { poem in
                viewModel.selectedPoem = poem
            },
            emptyView: {
                Text("user.profile.poems.emptyState.prompt").monospaced()
            }
        )
        .navigationDestination(item: $viewModel.selectedPoem) { poem in
            if let currentUser = appMain.currentUser,
               currentUser.userId == authorId {
                YourPoemView(
                    poem: poem,
                    onDeleteCompleted: onDeletePoemCompleted
                )
            } else {
                UserPoemView(
                    poem: poem,
                    hasVisitAuthorMenuButton: false
                )
            }
        }
    }
}

extension UserProfileView {
    private func onDeletePoemCompleted() {
        viewModel.selectedPoem = nil
    }
}

#Preview {
    UserProfileView(authorId: "123")
}
