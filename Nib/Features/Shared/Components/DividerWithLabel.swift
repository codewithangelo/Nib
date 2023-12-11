//
//  DividerWithLabel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct DividerWithLabel: View {
    let label: String
    let padding: CGFloat
    
    init(label: String, padding: CGFloat = 20) {
        self.label = label
        self.padding = padding
    }
    
    var body: some View {
        HStack {
            VStack {
                Divider()
            }
            Text(label)
                .padding(padding)
            VStack {
                Divider()
            }
        }
    }
}

#Preview {
    DividerWithLabel(label: "Or")
}
