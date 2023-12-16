//
//  AppRootView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct AppRootView: View {
    private static let authenticationService: NibAuthenticationServiceProtocol = NibAuthenticationService()
    
    @StateObject
    var viewModel: AppRootViewModel = AppRootViewModel(authenticationService: authenticationService)
    
    var body: some View {
        ZStack {
            if (!viewModel.showSignInView) {
                AppMainView()
                    .toastView(toast: $viewModel.toast)
                    .environmentObject(viewModel)
            }
        }
        .onAppear(perform: checkIsUserAuthenticated)
        .fullScreenCover(isPresented: $viewModel.showSignInView) {
            SignInView(
                onSignInCompleted: onSignInCompleted,
                onSignInError: onSignInError
            )
            .toastView(toast: $viewModel.toast)
        }
    }
}

extension AppRootView {
    private func onSignInCompleted() {
        viewModel.showSignInView = false
    }
    
    private func onSignInError() {
        viewModel.toast = Toast(
            style: .error,
            message: NSLocalizedString("app.signIn.error", comment: "")
        )
    }
}

extension AppRootView {
    private func checkIsUserAuthenticated() {
        viewModel.checkIsUserAuthenticated()
    }
}

#Preview {
    AppRootView()
}
