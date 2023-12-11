//
//  UsernameViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

@MainActor
final class UsernameViewModel: ObservableObject {
    @Published
    var username: String
    
    private let currentUser: User?
    private let userService: UserServiceProtocol
    
    init(
        currentUser: User?,
        userService: UserServiceProtocol
    ) {
        self.currentUser = currentUser
        self.username = currentUser?.displayName ?? ""
        self.userService = userService
    }
    
    func updateUsername() async throws {
        guard let user = self.currentUser else {
            // TODO: Throw error
            return
        }
        
        let oldUsername = Username(userId: user.userId, username: user.displayName ?? "")
        let newUsername = Username(userId: user.userId, username: username)
        try await userService.updateUsername(oldUsername: oldUsername, newUsername: newUsername)
    }
}
