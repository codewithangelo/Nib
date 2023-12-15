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
    
    @Published
    var toast: Toast? = nil
    
    private let authenticationService: NibAuthenticationServiceProtocol
    
    init(authenticationService: NibAuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
    }
    
    func checkIsUserAuthenticated() {
        let authUser = try? authenticationService.getAuthenticatedUser()
        self.showSignInView = authUser == nil
    }
}
