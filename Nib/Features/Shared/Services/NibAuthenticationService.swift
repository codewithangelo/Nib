//
//  NibAuthenticationService.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import FirebaseAuth
import Foundation

final class NibAuthenticationService: NibAuthenticationServiceProtocol {
    private enum AuthenticationError: LocalizedError {
        case unableToGetCurrentUser
        
        var errorDescription: String? {
            switch self {
            case .unableToGetCurrentUser:
                return "Unable to get current user"
            }
        }
    }
    
    func getAuthenticatedUser() throws -> AuthDataResult {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.unableToGetCurrentUser
        }
        
        return AuthDataResult(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.unableToGetCurrentUser
        }
        
        try await user.delete()
    }
}

// MARK: SIGN IN SSO
extension NibAuthenticationService {
    func signInWithGoogle(tokens: GoogleSignInResult) async throws -> AuthDataResult {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResult {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(credential: credential)
    }
    
    private func signIn(credential: AuthCredential) async throws -> AuthDataResult {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResult(user: authDataResult.user)
    }
}
