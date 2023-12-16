//
//  AppMainView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-15.
//

import SwiftUI

struct AppMainView: View {
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    private static let authenticationService: NibAuthenticationServiceProtocol = NibAuthenticationService()
    private static let userService: UserServiceProtocol = UserService()
    
    @StateObject
    private var viewModel: AppMainViewModel = AppMainViewModel(
        authenticationService: authenticationService,
        userService: userService
    )
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .unset:
                EmptyView()
            case .loading:
                ProgressView()
            case .error:
                Text("app.main.unableToGetCurrentUser")
            case .success:
                TabView(selection: $viewModel.tabSelection) {
                    PoemFeedView()
                        .tag(AppMainViewModel.Tab.home)
                        .tabItem { Image(systemName: "house") }
                        .environmentObject(appRoot)
                    
                    DraftView()
                        .tag(AppMainViewModel.Tab.publisher)
                        .tabItem { Image(systemName: "plus.app") }
                        .environmentObject(viewModel)
                    
                    YourProfileView()
                        .tag(AppMainViewModel.Tab.userProfile)
                        .tabItem { Image(systemName: "person.crop.circle") }
                        .environmentObject(appRoot)
                        .environmentObject(viewModel)
                }
            }
        }
        .onAppear(perform: loadCurrentUserData)
    }
}

extension AppMainView {
    private func loadCurrentUserData() {
        Task {
            do {
                try await viewModel.loadCurrentUserData()
            } catch {
                // Silently fail
            }
        }
    }
}

#Preview {
    AppMainView()
        .environmentObject(
            AppRootViewModel(authenticationService: NibAuthenticationService())
        )
}
