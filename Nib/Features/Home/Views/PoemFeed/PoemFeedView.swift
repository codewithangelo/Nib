//
//  PoemFeedView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct PoemFeedView: View {        
    @State
    private var showReportPoemView: Bool = false
    
    @State
    private var selectedPoem: Poem? = nil
    
    var body: some View {
        NavigationStack {
            PoemMasonryView(
                authorId: nil,
                onPoemTap: { poem in
                    selectedPoem = poem
                }
            )
            .navigationDestination(item: $selectedPoem) { poem in
                UserPoemView(poem: poem)
                    .toolbar(content: poemToolbar)
                    .sheet(isPresented: $showReportPoemView) {
                        ReportPoemView(
                            poem: poem,
                            onReportCompleted: { showReportPoemView = false }
                        )
                            .presentationDetents([.medium, .large])
                    }
            }
        }
    }
}

extension PoemFeedView {
    @ToolbarContentBuilder
    private func poemToolbar() -> some ToolbarContent {
        ToolbarItem {
            Menu {
                Button(
                    role: .destructive,
                    action: { showReportPoemView = true },
                    label: { Text("Report") }
                )
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}

#Preview {
    PoemFeedView()
}
