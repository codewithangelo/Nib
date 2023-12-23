//
//  YourProfileView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct YourProfileView: View {
    private enum Tab {
        case yourPoems
        case favoritePoems
    }
    
    @State
    private var showSettingsView: Bool = false
    
    @State
    private var tabSelection: Tab = .yourPoems
    
    @Namespace
    private var animation
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .center) {
                    yourPoemsTab
                    yourFavoritesTab
                }
                Divider()
                Spacer()
                switch tabSelection {
                case .yourPoems:
                    YourPoemsView()
                case .favoritePoems:
                    YourFavoritesView()
                }
            }
            .toolbar(content: yourProfileToolbar)
            .navigationDestination(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
    }
}

extension YourProfileView {
    private var tabUnderline: some View {
        Capsule()
            .fill(.blue)
            .frame(height: 1)
            .offset(y: 8)
            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
    }
    
    private var yourPoemsTab: some View {
        Button(
            action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    tabSelection = .yourPoems
                }
            },
            label: {
                Image(systemName: "square.grid.2x2.fill")
                    .frame(width: 32, height: 32)
            }
        )
        .padding(.bottom, 0)
        .foregroundColor(tabSelection == .yourPoems ? .blue : .gray)
        .frame(maxWidth: .infinity)
        .background(alignment: .bottom) {
            if tabSelection == .yourPoems {
                tabUnderline
            }
        }
    }
    
    private var yourFavoritesTab: some View {
        Button(
            action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    tabSelection = .favoritePoems
                }
            },
            label: {
                Image(systemName: "bookmark.fill")
                    .frame(width: 32, height: 32)
            }
        )
        .padding(.bottom, 0)
        .foregroundColor(tabSelection == .favoritePoems ? .blue : .gray)
        .frame(maxWidth: .infinity)
        .background(alignment: .bottom) {
            if tabSelection == .favoritePoems {
                tabUnderline
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
