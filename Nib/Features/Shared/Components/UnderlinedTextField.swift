//
//  UnderlinedTextField.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

private struct ClearButton: ViewModifier {
    @Binding
    var text: String
    
    public func body(content: Content) -> some View {
        HStack {
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

struct UnderlinedTextField: View {
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
    UnderlinedTextField(label: "Label", text: .constant("Text"))
}
