//
//  SignInView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack {
            appTitle
            signInWithAppleButton
            DividerWithLabel(label: "Or")
            signInWithGoogleButton
        }
    }
}

extension SignInView {
    private var appTitle: some View {
        Text("Nib")
            .font(.largeTitle)
            .bold()
    }
    
    private var signInWithAppleButton: some View {
        SignInWithAppleButton {
            
        }
    }
    
    private var signInWithGoogleButton: some View {
        SignInWithGoogleButton {
            
        }
    }
}

#Preview {
    SignInView()
}
