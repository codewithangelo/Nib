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
            case .success(let author):
                VStack(alignment: .leading) {
                    Text(poem.title)
                        .bold()
                        .font(.title)
                    
                    Text("poem.writtenBy \(author.username)")
                        .monospaced()
                        .padding(.bottom)
                    
                    Text(poem.content)
                        .monospaced()
                    
                    Spacer()
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear(perform: loadAuthor)
    }
}

extension UserPoemView {
    func loadAuthor() {
        Task {
            do {
                try await viewModel.loadAuthorName(poem: poem)
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("poem.author.error", comment: "")
                )
            }
        }
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
