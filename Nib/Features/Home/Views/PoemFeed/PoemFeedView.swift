//
//  PoemFeedView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct PoemFeedView: View {
    @EnvironmentObject
    var appMain: AppMainViewModel
    
    @StateObject
    private var viewModel: PoemFeedViewModel = PoemFeedViewModel()
    
    var body: some View {
        NavigationStack {
            PoemMasonryView(
                authorId: nil,
                onPoemTap: { poem in
                    viewModel.selectedPoem = poem
                },
                emptyView: {
                    goToPublisherPrompt
                }
            )
            .navigationDestination(item: $viewModel.selectedPoem) { poem in
                UserPoemView(poem: poem)
                    .toolbar(content: poemToolbar)
                    .sheet(isPresented: $viewModel.showReportPoemView) {
                        ReportPoemView(
                            poem: poem,
                            onReportCompleted: hideReportSheet
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
                    action: showReportSheet,
                    label: { Text("poem.menu.buttons.report") }
                )
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    private var goToPublisherPrompt: some View {
        Button(
            action: { appMain.tabSelection = .publisher },
            label: { Text("feed.emptyState.prompt").monospaced() }
        )
    }
}

extension PoemFeedView {
    private func hideReportSheet() {
        viewModel.showReportPoemView = false
    }
    
    private func showReportSheet() {
        viewModel.showReportPoemView = true
    }
}

#Preview {
    PoemFeedView()
}
