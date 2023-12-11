//
//  UsernameView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct UsernameView: View {
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
            TextInput(label: "Username", text: $viewModel.username)
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Username")
        .toolbar(content: usernameToolbar)
    }
}

extension UsernameView {
    @ToolbarContentBuilder
    func usernameToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(
                action: confirmUsername,
                label: { Text("Done") }
            )
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
                print(error)
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
