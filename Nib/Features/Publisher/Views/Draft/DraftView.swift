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
    
    @State
    private var showDismissKeyboard: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationView {
                VStack(alignment: .leading) {
                    TextField(
                        NSLocalizedString("poem.draft.title.placeholder", comment: ""),
                        text: $viewModel.title,
                        axis: .vertical
                    )
                    .bold()
                    .font(.title)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .titleField)
                    
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
                        .padding(.bottom, showDismissKeyboard ? 40 : 0)
                    }
                    .onTapGesture {
                        focusedField = .contentField
                        withAnimation(.easeInOut(duration: 1.0)) {
                            showDismissKeyboard = true
                        }
                    }
                    .monospaced()
                    .autocorrectionDisabled()
                    
                    Spacer()
                }
                .onAppear(perform: focusTextFieldOnAppear)
                .padding()
                .toolbar(content: draftToolbar)
                .onChange(of: focusedField) { _, value in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showDismissKeyboard = value != nil
                    }
                }
            }
            
            if showDismissKeyboard {
                VStack {
                    Button(
                        action: { focusedField = nil },
                        label: { Image(systemName: "xmark") }
                    )
                    .padding()
                }
                .background(Color(UIColor.systemGray6))
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
                .padding([.bottom, .trailing], 12)
                
            }
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
