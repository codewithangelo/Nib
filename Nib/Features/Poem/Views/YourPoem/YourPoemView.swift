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
                Text(poem.title)
                    .bold()
                    .font(.title)
                
                if let currentUser = app.currentUser,
                   let displayName = currentUser.displayName {
                    Text("Written by \(displayName)")
                        .monospaced()
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
