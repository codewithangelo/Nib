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
    private var viewModel: YourPoemsViewModel = YourPoemsViewModel(poemService: poemService)
    
    var body: some View {
        
        if let currentUser = appMain.currentUser {
            PoemMasonryView(
                authorId: currentUser.userId,
                onPoemTap: { poem in
                    viewModel.selectedPoem = poem
                },
                emptyView: {
                    goToPublisherPrompt
                }
            )
            .navigationDestination(item: $viewModel.selectedPoem) { poem in
                YourPoemView(poem: poem)
                    .toolbar(content: poemToolbar)
            }
        } else {
            EmptyView()
        }
    }
}

extension YourPoemsView {
    @ToolbarContentBuilder
    private func poemToolbar() -> some ToolbarContent {
        ToolbarItem {
            Menu {
                Button(
                    role: .destructive,
                    action: deleteSelectedPoem,
                    label: { Text("poem.menu.buttons.delete") }
                )
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    private var goToPublisherPrompt: some View {
        Button(
            action: { appMain.tabSelection = .publisher },
            label: { Text("your.poems.emptyState.prompt").monospaced() }
        )
    }
}

extension YourPoemsView {
    private func deleteSelectedPoem() {
        Task {
            do {
                try await viewModel.deleteSelectedPoem()
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("poem.delete.error", comment: "")
                )
            }
        }
    }
}

#Preview {
    YourPoemsView()
}
