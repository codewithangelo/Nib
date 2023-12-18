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
    private let userService: UserServiceProtocol
    
    init(
        authenticationService: NibAuthenticationServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.authenticationService = authenticationService
        self.userService = userService
    }
    
    func deleteAccount(user: User) async throws {
        try await userService.deleteUser(user: user)
        try await authenticationService.delete()
    }
    
    func signOut() throws {
        try authenticationService.signOut()
    }
}
