//
//  AppMainViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-15.
//

import Foundation

@MainActor
final class AppMainViewModel: ObservableObject {
    enum AppMainViewModelError: LocalizedError {
        case unableToGetCurrentUser
        
        var errorDescription: String? {
            switch self {
            case .unableToGetCurrentUser:
                return NSLocalizedString("app.main.unableToGetCurrentUser", comment: "")
            }
        }
    }
    
    enum State: Equatable {
        case unset
        case loading
        case error(error: String?)
        case success(currentUser: User)
    }
    
    @Published
    var state: State = .unset
    
    @Published
    var currentUser: User? = nil
    
    enum Tab {
        case home
        case publisher
        case userProfile
    }
    
    @Published
    var tabSelection: Tab = .home
    
    private let authenticationService: NibAuthenticationServiceProtocol
    private let userService: UserServiceProtocol
    
    init(
        authenticationService: NibAuthenticationServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.authenticationService = authenticationService
        self.userService = userService
    }
    
    func loadCurrentUserData() async throws {
        guard let authUser = try? authenticationService.getAuthenticatedUser() else {
            return
        }
        
        self.state = .loading
        
        do {
            guard let currentUser = try? await userService.getUser(userId: authUser.uid) else {
                self.state = .error(error: AppMainViewModelError.unableToGetCurrentUser.errorDescription)
                throw AppMainViewModelError.unableToGetCurrentUser
            }
            self.state = .success(currentUser: currentUser)
            self.currentUser = currentUser
        } catch {
            try await createNewUser(authUser: authUser)
        }
    }
    
    func refreshCurrentUserDataInBackground() async throws {
        guard let authUser = try? authenticationService.getAuthenticatedUser() else {
            return
        }
        guard let currentUser = try? await userService.getUser(userId: authUser.uid) else {
            throw AppMainViewModelError.unableToGetCurrentUser
        }
        self.currentUser = currentUser
    }
    
    private func createNewUser(authUser: AuthDataResult) async throws {
        do {
            let newUser = User(authDataResult: authUser)
            try await userService.createNewUser(user: newUser)
            self.state = .success(currentUser: newUser)
            self.currentUser = newUser
        } catch {
            self.state = .error(error: AppMainViewModelError.unableToGetCurrentUser.errorDescription)
            throw AppMainViewModelError.unableToGetCurrentUser
        }
    }
}
