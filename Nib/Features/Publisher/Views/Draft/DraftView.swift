//
//  DraftView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct DraftView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject
    var app: AppRootViewModel
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: DraftViewModel = DraftViewModel(poemService: poemService)
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("Untitled", text: $viewModel.title, axis: .vertical)
                    .bold()
                    .font(.title)
                    .autocorrectionDisabled()
                TextField("Lorem ipsum...", text: $viewModel.content, axis: .vertical)
                    .monospaced()
                    .autocorrectionDisabled()
                Spacer()
            }
            .padding()
            .toolbar(content: draftToolbar)
        }
    }
}

extension DraftView {
    @ToolbarContentBuilder
    func draftToolbar() -> some ToolbarContent {
        ToolbarItem {
            NavigationLink(
                destination: {
                    PreviewView(
                        title: $viewModel.title,
                        content: $viewModel.content,
                        publish: publishPoem
                    )
                },
                label: { Text("Next") }
            )
        }
    }
}

extension DraftView {
    private func publishPoem() {
        guard let author = app.currentUser else {
            // TODO: Throw error
            return
        }
        
        Task {
            do {
                try await viewModel.publishPoem(user: author)
                viewModel.reset()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    DraftView()
        .environmentObject(
            AppRootViewModel(
                authenticationService: NibAuthenticationService(),
                userService: UserService()
            )
        )
}
