//
//  YourPoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct YourPoemView: View {
    @EnvironmentObject
    var app: AppMainViewModel

    let poem: Poem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let currentUser = app.currentUser,
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
}
