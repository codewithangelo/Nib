//
//  RadioButton.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-12.
//

import SwiftUI

struct RadioButton<Content: View>: View {
    let id: String
    let checked: Bool
    let onCheck: (String) -> Void
    
    @ViewBuilder
    let label: Content

    var body: some View {
        HStack(alignment: .top) {
            Button(
                action: { onCheck(id) },
                label: { Image(systemName: checked ? "checkmark.circle.fill" : "circle") }
            )
            
            label
        }
        .onTapGesture {
            onCheck(id)
        }
        .padding(.bottom, 4)
    }
}
#Preview {
    RadioButton(
        id: "radio",
        checked: true,
        onCheck: { id in },
        label: { Text("Radio button") }
    )
}
