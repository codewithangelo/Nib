//
//  SignInWithGoogleButton.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import GoogleSignInSwift
import SwiftUI

struct SignInWithGoogleButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        GoogleSignInButton(
            viewModel: GoogleSignInButtonViewModel(
                scheme: colorScheme == .light ? .light : .dark,
                style: .wide,
                state: .normal
            ),
            action: action
        )
    }
}

#Preview {
    SignInWithGoogleButton { }
}
