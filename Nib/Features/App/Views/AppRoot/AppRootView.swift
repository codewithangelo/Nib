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
    
    @State private var toast: Toast? = nil
    
    var body: some View {
        ZStack {
            if (!viewModel.showSignInView) {
                AppMainView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear(perform: checkIsUserAuthenticated)
        .fullScreenCover(isPresented: $viewModel.showSignInView) {
            SignInView(
                onSignInCompleted: onSignInCompleted,
                onSignInError: onSignInError
            )
            .toastView(toast: $toast)
        }
    }
}

extension AppRootView {
    private func onSignInCompleted() {
        viewModel.showSignInView = false
    }
    
    private func onSignInError() {
        toast = Toast(
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
