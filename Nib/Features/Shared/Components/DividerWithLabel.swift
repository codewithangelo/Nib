//
//  DividerWithLabel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct DividerWithLabel<Content: View>: View {
    @ViewBuilder
    let label: Content
    let padding: CGFloat
    
    init(label: Content, padding: CGFloat = 20) {
        self.label = label
        self.padding = padding
    }
    
    var body: some View {
        HStack {
            VStack {
                Divider()
            }
            label
                .padding(padding)
            VStack {
                Divider()
            }
        }
    }
}

#Preview {
    DividerWithLabel(label: Text("Or"))
}
