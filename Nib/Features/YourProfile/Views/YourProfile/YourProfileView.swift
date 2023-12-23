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
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded { value in
                    switch(value.translation.width, value.translation.height) {
                    case (...0, -30...30):
                        withAnimation(.easeInOut(duration: 0.3)) {
                            tabSelection = .favoritePoems
                        }
                    case (0..., -30...30):
                        withAnimation(.easeInOut(duration: 0.3)) {
                            tabSelection = .yourPoems
                        }
                    case (-100...100, ...0):
                        break
                    case (-100...100, 0...):
                        break
                    default:
                        break
                    }
                }
            )
        }
    }
}

extension YourProfileView {
    private var tabUnderline: some View {
        Capsule()
            .fill(.blue)
            .frame(height: 2)
            .offset(y: 11)
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
                Text("user.profile.your.poems.tab")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.horizontal)
            }
        )
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
                Text("user.profile.favorites.tab")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.horizontal)
            }
        )
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
