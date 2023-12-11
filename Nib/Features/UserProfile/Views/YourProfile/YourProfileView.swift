//
//  YourProfileView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct YourProfileView: View {
    @State
    private var showSettingsView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Profile")
            }
            .toolbar(content: yourProfileToolbar)
            .navigationDestination(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
    }
}

extension YourProfileView {
    @ToolbarContentBuilder
    func yourProfileToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(
                action: { showSettingsView.toggle() },
                label: { Image(systemName: "line.3.horizontal") }
            )
        }
    }
}

#Preview {
    YourProfileView()
}
