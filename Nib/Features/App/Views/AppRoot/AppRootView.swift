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
                YourProfileView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.loadCurrentUser()
        }
        .fullScreenCover(isPresented: $viewModel.showSignInView) {
            SignInView(
                onSignInCompleted: { viewModel.showSignInView = false },
                onSignInError: { }
            )
        }
    }
}

#Preview {
    AppRootView()
}
