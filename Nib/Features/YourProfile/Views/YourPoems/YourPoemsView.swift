//
//  YourPoemsView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct YourPoemsView: View {
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: YourPoemsViewModel = YourPoemsViewModel()
    
    var body: some View {
        if let currentUser = appMain.currentUser {
            UserProfileView(authorId: currentUser.userId)
        } else {
            EmptyView()
        }
    }
}

extension YourPoemsView {
    private var goToPublisherPrompt: some View {
        Button(
            action: { appMain.tabSelection = .publisher },
            label: { Text("your.poems.emptyState.prompt").monospaced() }
        )
    }
    
    private func onDeletePoemCompleted() {
        viewModel.selectedPoem = nil
    }
}

#Preview {
    YourPoemsView()
}
