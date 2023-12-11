//
//  SettingsViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    private let authenticationService: NibAuthenticationServiceProtocol
    
    init(authenticationService: NibAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }
    
    func deleteAccount() async throws {
        try await authenticationService.delete()
    }
    
    func signOut() throws {
        try authenticationService.signOut()
    }
}
