//
//  UsernameView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct UsernameView: View {
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    private static let userService: UserServiceProtocol = UserService()
    
    @StateObject
    private var viewModel: UsernameViewModel
    
    let onDone: () -> Void
    
    init(
        currentUser: User?,
        onDone: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: UsernameViewModel(
                currentUser: currentUser,
                userService: UserService()
            )
        )
        self.onDone = onDone
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 16)
            UnderlinedTextField(
                label: NSLocalizedString("settings.username.field.prompt", comment: ""),
                text: $viewModel.username
            )
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("settings.username.toolbar.title")
        .toolbar(content: usernameToolbar)
    }
}

extension UsernameView {
    @ToolbarContentBuilder
    func usernameToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(
                action: confirmUsername,
                label: { Text("settings.username.toolbar.buttons.done") }
            )
            .disabled(!viewModel.isValid)
        }
    }
}

extension UsernameView {
    private func confirmUsername() {
        Task {
            do {
                try await viewModel.updateUsername()
                onDone()
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("settings.username.update.error", comment: "")
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        UsernameView(
            currentUser: User(userId: "123", displayName: "Angelo"),
            onDone: { }
        )
    }
}
