//
//  PreviewView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-12.
//

import SwiftUI

struct PreviewView: View {
    @EnvironmentObject
    var app: AppMainViewModel
    
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
                if let currentUser = app.currentUser,
                   let displayName = currentUser.displayName, !displayName.isEmpty {
                    Text(title)
                        .bold()
                        .font(.title)
                    Text("poem.writtenBy \(displayName)")
                        .monospaced()
                        .padding(.bottom)
                } else {
                    Text(title)
                        .bold()
                        .font(.title)
                        .padding(.bottom)
                }
                
                Text(content)
                    .monospaced()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("poem.preview.toolbar.title")
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
                label: { Text("poem.preview.toolbar.buttons.publish") }
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
