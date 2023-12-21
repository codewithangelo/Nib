//
//  YourPoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct YourPoemView: View {
    let poem: Poem
    var onDeleteCompleted: (() -> Void)? = nil
    
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: YourPoemViewModel = YourPoemViewModel(poemService: poemService)
    
    @State
    private var scrollPosition: CGPoint = .zero
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading) {
                    if let currentUser = appMain.currentUser,
                       let displayName = currentUser.displayName, !displayName.isEmpty {
                        Text(poem.title)
                            .bold()
                            .font(.title)
                        
                        Text("poem.writtenBy \(displayName)")
                            .monospaced()
                            .padding(.bottom)
                    } else {
                        Text(poem.title)
                            .bold()
                            .font(.title)
                            .padding(.bottom)
                    }
                    
                    Text(poem.content)
                        .monospaced()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        scrollPosition = value
                    }
                }
            }
            .toolbar(content: poemToolbar)
            .coordinateSpace(name: "scroll")
            
            LikeButtonView(poem: poem)
                .opacity(scrollPosition.y > 0 ? 1 : 0)
                .padding([.bottom, .trailing], 12)
        }
    }
}

extension YourPoemView {
    @ToolbarContentBuilder
    private func poemToolbar() -> some ToolbarContent {
        ToolbarItem {
            Menu {
                Button(
                    role: .destructive,
                    action: deletePoem,
                    label: { Text("poem.menu.buttons.delete") }
                )
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}

extension YourPoemView {
    private func deletePoem() {
        Task {
            do {
                try await viewModel.deletePoem(poem: poem)
                onDeleteCompleted?()
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("poem.delete.error", comment: "")
                )
            }
        }
    }
}

#Preview {
    YourPoemView(
        poem: Poem(
            authorId: "123",
            content: "Lorem Ipsum",
            title: "Title"
        )
    )
    .environmentObject(
        AppMainViewModel(
            authenticationService: NibAuthenticationService(),
            userService: UserService()
        )
    )
    .environmentObject(
        AppRootViewModel(
            authenticationService: NibAuthenticationService()
        )
    )
}
