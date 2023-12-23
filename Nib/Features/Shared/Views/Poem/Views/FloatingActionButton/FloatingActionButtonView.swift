//
//  FloatingActionButtonView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-21.
//

import SwiftUI

struct FloatingActionButtonView: View {
    let poem: Poem
    
    var body: some View {
        VStack {
            LikeButtonView(poem: poem)
                .padding(.bottom, 8)
            FavoriteButtonView(poem: poem)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 4, x: 0, y: 4)
    }
}

#Preview {
    FloatingActionButtonView(
        poem: Poem(
            authorId: "123",
            content: "Lorem ipsum",
            id: "1",
            title: "Lorem ipsum"
        )
    )
}
