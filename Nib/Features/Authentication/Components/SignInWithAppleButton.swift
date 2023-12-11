//
//  SignInWithAppleButton.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import AuthenticationServices
import SwiftUI
import UIKit

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

struct SignInWithAppleButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            SignInWithAppleButtonViewRepresentable(type: .default, style: colorScheme == .light ? .black : .white)
                .allowsHitTesting(false)
                .frame(height: 48)
        }
    }
}

#Preview {
    SignInWithAppleButton { }
}
