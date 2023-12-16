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
    var app: AppMainViewModel
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: DraftViewModel = DraftViewModel(poemService: poemService)
    
    @State
    private var toast: Toast? = nil
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField(
                    NSLocalizedString("poem.draft.title.placeholder", comment: ""),
                    text: $viewModel.title,
                    axis: .vertical
                )
                .bold()
                .font(.title)
                .autocorrectionDisabled()
                
                ZStack(alignment: .topLeading) {
                    if viewModel.content.isEmpty {
                        Text("poem.draft.content.placeholder")
                            .foregroundStyle(Color.gray.opacity(0.6))
                    }
                    
                    TextField(
                        "",
                        text: $viewModel.content,
                        axis: .vertical
                    )
                }
                .monospaced()
                .autocorrectionDisabled()
                Spacer()
            }
            .padding()
            .toolbar(content: draftToolbar)
            .toastView(toast: $toast)
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
                label: { Text("poem.draft.toolbar.buttons.next") }
            )
        }
    }
}

extension DraftView {
    private func publishPoem() {
        guard let author = app.currentUser else {
            toast = Toast(
                style: .error,
                message: NSLocalizedString("poem.publish.error", comment: "")
            )
            return
        }
        
        Task {
            do {
                try await viewModel.publishPoem(user: author)
                viewModel.reset()
                toast = Toast(
                    style: .success,
                    message: NSLocalizedString("poem.publish.success", comment: "")
                )
            } catch {
                toast = Toast(
                    style: .error,
                    message: NSLocalizedString("poem.publish.error", comment: "")
                )
            }
        }
    }
}

#Preview {
    DraftView()
        .environmentObject(
            AppMainViewModel(
                authenticationService: NibAuthenticationService(),
                userService: UserService()
            )
        )
}
