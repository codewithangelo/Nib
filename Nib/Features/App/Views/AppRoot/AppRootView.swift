//
//  AppRootView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct AppRootView: View {
    private static let authenticationService: NibAuthenticationServiceProtocol = NibAuthenticationService()
    private static let usernService: UserServiceProtocol = UserService()
    
    @StateObject
    var viewModel: AppRootViewModel = AppRootViewModel(
        authenticationService: authenticationService,
        userService: usernService
    )
    
    var body: some View {
        ZStack {
            if (!viewModel.showSignInView) {
                TabView {
                    DraftView()
                        .tabItem { Image(systemName: "plus.app") }
                        .environmentObject(viewModel)
                    
                    YourProfileView()
                        .tabItem { Image(systemName: "person.crop.circle") }
                        .environmentObject(viewModel)
                }
                .onAppear(perform: loadCurrentUserData)
            }
        }
        .onAppear(perform: checkIsUserAuthenticated)
        .fullScreenCover(isPresented: $viewModel.showSignInView) {
            SignInView(
                onSignInCompleted: { viewModel.showSignInView = false },
                onSignInError: { }
            )
        }
    }
}

extension AppRootView {
    private func checkIsUserAuthenticated() {
        viewModel.checkIsUserAuthenticated()
    }
    
    private func loadCurrentUserData() {
        Task {
            do {
                try await viewModel.loadCurrentUserData()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    AppRootView()
}
