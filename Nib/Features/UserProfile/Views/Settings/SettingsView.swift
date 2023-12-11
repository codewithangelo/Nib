//
//  SettingsView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject
    var app: AppRootViewModel
    
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
            Section("Account") {
                usernameButton
                    .navigationDestination(isPresented: $showUsernameView) {
                        UsernameView(
                            currentUser: app.currentUser!,
                            onDone: onUsernameDone
                        )
                    }
                deleteAccountButton
            }
            
            Section("App") {
                signOutButton
            }
        }
        .navigationTitle("Settings")
    }
}

extension SettingsView {
    private var usernameButton: some View {
        Button(
            action: { showUsernameView = true },
            label: {
                Text("Username")
            }
        )
    }
    
    private var deleteAccountButton: some View {
        Button(
            role: .destructive,
            action: deleteAccount,
            label: {
                Text("Delete Account")
            }
        )
    }
            
    private var signOutButton: some View {
        Button(
            action: signOut,
            label: {
                Text("Sign Out")
            }
        )
    }
}

extension SettingsView {
    private func onUsernameDone() {
        Task {
            do {
                try await app.loadCurrentUserData()
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
                app.showSignInView = true
            } catch {
                print(error)
            }
        }
    }
    
    private func signOut() {
        Task {
            do {
                try viewModel.signOut()
                app.showSignInView = true
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
