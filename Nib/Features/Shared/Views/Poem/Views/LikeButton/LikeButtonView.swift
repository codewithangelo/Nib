//
//  LikeButtonView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-20.
//

import SwiftUI

struct LikeButtonView: View {
    let poem: Poem
    
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    private static let likeService: LikeServiceProtocol = LikeService()
    
    @StateObject
    private var viewModel: LikeButtonViewModel = LikeButtonViewModel(likeService: likeService)
    
    var body: some View {
        VStack {
            Button(
                action: viewModel.liked ? unlikePoem : likePoem,
                label: { Image(systemName: viewModel.liked ? "heart.fill" : "heart") }
            )
            .onAppear(perform: loadHasUserLikedPoem)
            Text("\(viewModel.likeCount.formatUsingAbbrevation())")
                .font(.footnote)
                .onAppear(perform: loadPoemLikeCount)
        }
    }
}

extension LikeButtonView {
    func loadHasUserLikedPoem() {
        guard let poemId = poem.id, let currentUser = appMain.currentUser else {
            // Silently error
            return
        }
        
        Task {
            do {
                try await viewModel.loadHasUserLikedPoem(poemId: poemId, user: currentUser)
            } catch {
                // Silently error
            }
        }
    }
    
    func loadPoemLikeCount() {
        guard let poemId = poem.id else {
            // Silently error
            return
        }
        
        Task {
            do {
                try await viewModel.loadPoemLikeCount(poemId: poemId)
            } catch {
                // Silently error
            }
        }
    }
    
    func likePoem() {
        guard let poemId = poem.id, let currentUser = appMain.currentUser else {
            appRoot.toast = Toast(
                style: .error,
                message: NSLocalizedString("poem.like.error", comment: "")
            )
            return
        }
        
        Task {
            do {
                try await viewModel.likePoem(poemId: poemId, user: currentUser)
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("poem.like.error", comment: "")
                )
            }
        }
    }
    
    func unlikePoem() {
        guard let poemId = poem.id, let currentUser = appMain.currentUser else {
            appRoot.toast = Toast(
                style: .error,
                message: NSLocalizedString("poem.unlike.error", comment: "")
            )
            return
        }
        
        Task {
            do {
                try await viewModel.unlikePoem(poemId: poemId, user: currentUser)
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("poem.unlike.error", comment: "")
                )
            }
        }
    }
}

#Preview {
    LikeButtonView(
        poem: Poem(
            authorId: "123",
            content: "Lorem ipsum",
            id: "1",
            title: "Lorem ipsum"
        )
    )
}
