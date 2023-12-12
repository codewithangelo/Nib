//
//  ReportPoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct ReportPoemView: View {
    let poem: Poem
    
    var body: some View {
        Text("Report")
            .font(.title)
    }
}

#Preview {
    ReportPoemView(poem: Poem(
        authorId: "123",
        content: "Lorem Ipsum",
        title: "Title"
    ))
}
