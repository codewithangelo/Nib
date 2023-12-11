//
//  PoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct PoemView: View {
    private static let poemService: PoemServiceProtocol = PoemService()
    
    @StateObject
    private var viewModel: PoemViewModel = PoemViewModel(poemService: poemService)
    
    let poem: Poem
    
    var body: some View {
        ScrollView {
            switch viewModel.state {
            case .loading:
                ProgressView()
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

extension PoemView {
    func loadAuthor() {
        Task {
            await viewModel.loadAuthorName(poem: poem)
        }
    }
}

#Preview {
    PoemView(
        poem: Poem(
            authorId: "123",
            content: "Content",
            title: "Title"
        )
    )
}
