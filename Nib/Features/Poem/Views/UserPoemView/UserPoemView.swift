//
//  PoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct UserPoemView: View {
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: UserPoemViewModel = UserPoemViewModel(poemService: poemService)
    
    let poem: Poem
    
    var body: some View {
        ScrollView {
            switch viewModel.state {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .error:
                EmptyView()
            case .success(let author):
                VStack(alignment: .leading) {
                    Text(poem.title)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
                    Text("Written by \(author.username)")
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
            await viewModel.loadAuthorName(poem: poem)
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
