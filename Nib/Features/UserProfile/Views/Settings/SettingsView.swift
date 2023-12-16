//
//  SettingsView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject
    var app: AppMainViewModel
    
    @EnvironmentObject
    var root: AppRootViewModel

    
    private static let authenticationService: NibAuthenticationServiceProtocol = NibAuthenticationService()
    private static let userService: UserServiceProtocol = UserService()
    
    @StateObject
    private var viewModel: SettingsViewModel = SettingsViewModel(
        authenticationService: authenticationService,
        userService: userService
    )
    
    @State
    private var showUsernameView: Bool = false
    
    var body: some View {
        List {
            Section("settings.list.section.title.account") {
                usernameButton
                    .navigationDestination(isPresented: $showUsernameView) {
                        UsernameView(
                            currentUser: app.currentUser,
                            onDone: onUsernameDone
                        )
                    }
                deleteAccountButton
            }
            
            Section("settings.list.section.title.app") {
                signOutButton
            }
        }
        .navigationTitle("settings.toolbar.title")
    }
}

extension SettingsView {
    private var usernameButton: some View {
        Button(
            action: { showUsernameView = true },
            label: {
                Text("settings.list.buttons.username")
            }
        )
    }
    
    private var deleteAccountButton: some View {
        Button(
            role: .destructive,
            action: deleteAccount,
            label: {
                Text("settings.list.buttons.deleteAccount")
            }
        )
    }
            
    private var signOutButton: some View {
        Button(
            action: signOut,
            label: {
                Text("settings.list.buttons.signOut")
            }
        )
    }
}

extension SettingsView {
    private func onUsernameDone() {
        Task {
            do {
                try await app.refreshCurrentUserDataInBackground()
                showUsernameView = false
            } catch {
                print(error)
            }
        }
    }
    
    private func deleteAccount() {
        guard let user = app.currentUser else {
            // TODO: Handle error
            return
        }
        
        Task {
            do {
                try await viewModel.deleteAccount(user: user)
                root.showSignInView = true
            } catch {
                print(error)
            }
        }
    }
    
    private func signOut() {
        Task {
            do {
                try viewModel.signOut()
                root.showSignInView = true
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
