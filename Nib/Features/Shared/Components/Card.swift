//
//  Card.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct Card: View {
    let title: String
    let content: String
    
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.systemGray6))
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .bold()
                            .padding()
                        
                        Text(content)
                            .fontDesign(.monospaced)
                            .padding([.leading, .bottom, .trailing])
                        Spacer()
                    }
                    .frame(alignment: .leading)
                    Spacer()
                }
            )
    }
}

#Preview {
    Card(title: "Title", content: "My Content")
}

