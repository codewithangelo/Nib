//
//  TextInput.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

private struct ClearButton: ViewModifier {
    @Binding
    var text: String
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if !text.isEmpty {
                Button(
                    action: { text = "" },
                    label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
            }
        }
    }
}

struct TextInput: View {
    let label: String
    
    @Binding
    var text: String
    
    var body: some View {
        TextField(label, text: $text)
            .modifier(ClearButton(text: $text))
            .padding(.bottom, 4)
        Divider()
    }
}

#Preview {
    TextInput(label: "Label", text: .constant("Text"))
}
