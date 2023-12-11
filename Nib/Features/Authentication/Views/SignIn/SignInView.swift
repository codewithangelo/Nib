//
//  SignInView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct SignInView: View {
    private static let authenticationService: NibAuthenticationServiceProtocol = NibAuthenticationService()
    
    @StateObject
    private var viewModel: SignInViewModel = SignInViewModel(authenticationService: authenticationService)
    
    let onSignInCompleted: () -> Void
    let onSignInError: () -> Void
    
    var body: some View {
        VStack {
            appTitle
            signInWithAppleButton
            DividerWithLabel(label: "Or")
            signInWithGoogleButton
        }
        .padding(.horizontal)
    }
}

extension SignInView {
    private var appTitle: some View {
        Text("Nib")
            .font(.largeTitle)
            .bold()
    }
    
    private var signInWithAppleButton: some View {
        SignInWithAppleButton(action: signInWithApple)
    }
    
    private var signInWithGoogleButton: some View {
        SignInWithGoogleButton(action: signInWithGoogle)
    }
}

extension SignInView {
    private func signInWithApple() {
        Task {
            do {
                try await viewModel.signInWithApple()
                self.onSignInCompleted()
            } catch {
                self.onSignInError()
            }
        }
    }
    
    private func signInWithGoogle() {
        Task {
            do {
                try await viewModel.signInWithGoogle()
                self.onSignInCompleted()
            } catch {
                self.onSignInError()
            }
        }
    }
}

#Preview {
    SignInView(
        onSignInCompleted: { },
        onSignInError: { }
    )
}
