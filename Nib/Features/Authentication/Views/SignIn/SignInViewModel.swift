//
//  SignInViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

@MainActor
final class SignInViewModel: ObservableObject {
    private let authenticationService: NibAuthenticationServiceProtocol
    
    init(authenticationService: NibAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }
    
    func signInWithApple() async throws {
        let helper = SignInWithAppleHelper.shared
        let tokens = try await helper.startSignInWithAppleFlow()
        try await authenticationService.signInWithApple(tokens: tokens)
    }
    
    func signInWithGoogle() async throws {
        let helper = SignInWithGoogleHelper()
        let tokens = try await helper.signIn()
        try await authenticationService.signInWithGoogle(tokens: tokens)
    }
}
