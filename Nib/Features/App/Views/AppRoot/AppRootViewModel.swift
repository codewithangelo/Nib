//
//  AppRootViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

@MainActor
final class AppRootViewModel: ObservableObject {    
    @Published
    var showSignInView: Bool = false
    
    private let authenticationService: NibAuthenticationServiceProtocol
    
    init(authenticationService: NibAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }
    
    func loadCurrentUser() {
        let authUser = try? authenticationService.getAuthenticatedUser()
        self.showSignInView = authUser == nil
    }
}
