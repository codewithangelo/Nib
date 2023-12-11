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
    
    @StateObject
    private var viewModel: SettingsViewModel = SettingsViewModel(authenticationService: authenticationService)
    
    var body: some View {
        List {
            Section("Account") {
                deleteAccoutButton
            }
            
            Section("App") {
                signOutButton
            }
        }
        .navigationTitle("Settings")
    }
}

extension SettingsView {
    private var deleteAccoutButton: some View {
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
    private func deleteAccount() {
        Task {
            do {
                try await viewModel.deleteAccount()
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
    SettingsView()
}
