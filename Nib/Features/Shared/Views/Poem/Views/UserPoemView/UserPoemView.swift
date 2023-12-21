//
//  PoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct UserPoemView: View {
    let poem: Poem
    var hasVisitAuthorMenuButton: Bool = false
    
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: UserPoemViewModel = UserPoemViewModel(poemService: poemService)
    
    @State
    private var scrollPosition: CGPoint = .zero
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                switch viewModel.state {
                case .unset:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .error:
                    VStack(alignment: .leading) {
                        poemTitle
                            .padding(.bottom)
                        poemContent
                        Spacer()
                    }
                    .padding()
                    .toolbar(content: poemToolbarWithNoAuthor)
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        withAnimation(.easeInOut(duration: 1.0)) {
                            scrollPosition = value
                        }
                    }
                case .success(let authorName):
                    VStack(alignment: .leading) {
                        poemTitle
                        Text("poem.writtenBy \(authorName.username)")
                            .monospaced()
                            .padding(.bottom)
                        poemContent
                        Spacer()
                    }
                    .padding()
                    .toolbar(content: poemToolbarWithAuthor)
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
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear(perform: loadAuthor)
            .sheet(isPresented: $viewModel.showReportPoemView) {
                ReportPoemView(poem: poem, onReportCompleted: hideReportSheet)
                    .presentationDetents([.medium, .large])
            }
            .navigationDestination(isPresented: $viewModel.showAuthorProfile) {
                UserProfileView(authorId: poem.authorId)
            }
            .coordinateSpace(name: "scroll")
            
            LikeButtonView(poem: poem)
                .opacity(scrollPosition.y > 0 ? 1 : 0)
                .padding([.bottom, .trailing], 12)
        }
    }
}

extension UserPoemView {
    private var poemTitle: some View {
        Text(poem.title)
            .bold()
            .font(.title)
    }
    
    private var poemContent: some View {
        Text(poem.content)
            .monospaced()
    }
}

extension UserPoemView {
    @ToolbarContentBuilder
    private func poemToolbarWithAuthor() -> some ToolbarContent {
        ToolbarItem {
            Menu {
                if hasVisitAuthorMenuButton {
                    Button(
                        action: goToAuthorProfile,
                        label: { Text("poem.menu.buttons.visitAuthor") }
                    )
                }
                
                Button(
                    role: .destructive,
                    action: showReportSheet,
                    label: { Text("poem.menu.buttons.report") }
                )
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func poemToolbarWithNoAuthor() -> some ToolbarContent {
        ToolbarItem {
            Menu {
                Button(
                    role: .destructive,
                    action: showReportSheet,
                    label: { Text("poem.menu.buttons.report") }
                )
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}

extension UserPoemView {
    private func loadAuthor() {
        Task {
            do {
                try await viewModel.loadAuthorName(poem: poem)
            } catch {
                // Silently error
            }
        }
    }
    
    private func hideReportSheet() {
        viewModel.showReportPoemView = false
    }
    
    private func showReportSheet() {
        viewModel.showReportPoemView = true
    }
    
    private func goToAuthorProfile() {
        viewModel.showAuthorProfile = true
    }
}

#Preview {
    UserPoemView(
        poem: Poem(
            authorId: "123",
            content: "Content",
            title: "Title"
        )
    )
}
