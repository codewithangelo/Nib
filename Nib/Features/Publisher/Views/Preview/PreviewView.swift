//
//  PreviewView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-12.
//

import SwiftUI

struct PreviewView: View {
    @EnvironmentObject
    var app: AppRootViewModel
    
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @Binding
    var title: String
    
    @Binding
    var content: String
    
    var publish: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .font(.title)
                
                if let currentUser = app.currentUser,
                   let displayName = currentUser.displayName {
                    Text("Written by \(displayName)")
                        .monospaced()
                        .padding(.bottom)
                }
                
                Text(content)
                    .monospaced()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Preview")
        .toolbar(content: previewToolbar)
    }
}

extension PreviewView {
    @ToolbarContentBuilder
    func previewToolbar() -> some ToolbarContent {
        ToolbarItem {
            Button(
                action: {
                    publish()
                    presentationMode.wrappedValue.dismiss()
                },
                label: { Text("Publish") }
            )
        }
    }
}

#Preview {
    PreviewView(
        title: .constant("Poem title"),
        content: .constant("Poem content"),
        publish: { }
    )
}
