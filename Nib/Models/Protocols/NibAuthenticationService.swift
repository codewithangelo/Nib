//
//  NibAuthenticationService.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

protocol NibAuthenticationService {
    func getProviders() throws -> [AuthProviderOption]
    
    func signOut() throws
    
    func delete() async throws
    
    func getAuthenticatedUser() throws -> AuthDataResult
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResult
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResult) async throws -> AuthDataResult
}
