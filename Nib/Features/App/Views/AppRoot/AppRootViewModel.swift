//
//  AppRootViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

@MainActor
final class AppRootViewModel: ObservableObject {
    @Published
    var currentUser: User? = nil
    
    @Published
    var showSignInView: Bool = false
    
    private let authenticationService: NibAuthenticationServiceProtocol
    private let userService: UserServiceProtocol
    
    init(
        authenticationService: NibAuthenticationServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.authenticationService = authenticationService
        self.userService = userService
    }
    
    func checkIsUserAuthenticated() {
        let authUser = try? authenticationService.getAuthenticatedUser()
        self.showSignInView = authUser == nil
    }
    
    func loadCurrentUserData() async throws {
        let authUser = try authenticationService.getAuthenticatedUser()
        
        do {
            let currentUser = try await userService.getUser(userId: authUser.uid)
            self.currentUser = currentUser
        } catch {
            let newUser = User(authDataResult: authUser)
            try await userService.createNewUser(user: newUser)
            self.currentUser = newUser
        }
    }
}
