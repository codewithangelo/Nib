//
//  DraftView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct DraftView: View {
    enum Field: Hashable {
        case titleField
        case contentField
    }
    
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: DraftViewModel = DraftViewModel(poemService: poemService)
    
    @FocusState
    private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField(
                    NSLocalizedString("poem.draft.title.placeholder", comment: ""),
                    text: $viewModel.title,
                    axis: .vertical
                )
                .focused($focusedField, equals: .titleField)
                .bold()
                .font(.title)
                .autocorrectionDisabled()
                .toolbar(content: keyboardToolbar)
                
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
                    .focused($focusedField, equals: .contentField)
                }
                .onTapGesture {
                    focusedField = .contentField
                }
                .monospaced()
                .autocorrectionDisabled()
                
                Spacer()
            }
            .onAppear(perform: focusTextFieldOnAppear)
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
                label: { Text("poem.draft.toolbar.buttons.next") }
            )
            .disabled(!viewModel.isValid)
        }
    }
    
    @ToolbarContentBuilder
    func keyboardToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            Button(
                action: { focusedField = nil },
                label: {
                    Text("keyboard.toolbar.buttons.done")
                        .font(.none)
                        .fontWeight(.regular)
                }
            )
        }
    }
}

extension DraftView {
    private func focusTextFieldOnAppear() {
        let task = DispatchWorkItem {
            focusedField = .contentField
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: task)
    }
    
    private func publishPoem() {
        guard let author = appMain.currentUser else {
            appRoot.toast = Toast(
                style: .error,
                message: NSLocalizedString("poem.publish.error", comment: "")
            )
            return
        }
        
        Task {
            do {
                try await viewModel.publishPoem(user: author)
                viewModel.reset()
                appRoot.toast = Toast(
                    style: .success,
                    message: NSLocalizedString("poem.publish.success", comment: "")
                )
            } catch {
                appRoot.toast = Toast(
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
