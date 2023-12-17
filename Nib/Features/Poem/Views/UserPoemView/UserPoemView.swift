//
//  PoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct UserPoemView: View {
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: UserPoemViewModel = UserPoemViewModel(poemService: poemService)
    
    let poem: Poem
    var hasVisitAuthorMenuButton: Bool = false
    
    var body: some View {
        ScrollView {
            switch viewModel.state {
            case .unset:
                EmptyView()
            case .loading:
                ProgressView()
            case .error:
                VStack(alignment: .leading) {
                    Text(poem.title)
                        .bold()
                        .font(.title)
                        .padding(.bottom)
                    
                    Text(poem.content)
                        .monospaced()
                    
                    Spacer()
                }
                .padding()
                .toolbar(content: poemToolbarWithNoAuthor)
            case .success:
                VStack(alignment: .leading) {
                    if let author = viewModel.author, !author.username.isEmpty {
                        Text(poem.title)
                            .bold()
                            .font(.title)
                        Text("poem.writtenBy \(author.username)")
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
                .padding()
                .toolbar(content: poemToolbarWithAuthor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear(perform: loadAuthor)
        .sheet(isPresented: $viewModel.showReportPoemView) {
            ReportPoemView(
                poem: poem,
                onReportCompleted: hideReportSheet
            )
            .presentationDetents([.medium, .large])
        }
        .navigationDestination(isPresented: $viewModel.showAuthorProfile) {
            PoemFeedView(authorId: poem.authorId, hasVisitAuthorMenuButton: false)
                .if(viewModel.author != nil) { view in
                    view.navigationTitle("\(viewModel.author!.username) feed.userPoems.toolbar.title")
                }
        }
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
