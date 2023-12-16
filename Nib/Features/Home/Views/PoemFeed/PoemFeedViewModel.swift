//
//  PoemFeedViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-15.
//

import Foundation

@MainActor
final class PoemFeedViewModel: ObservableObject {
    @Published
    var selectedPoem: Poem? = nil
    
    @Published
    var showReportPoemView: Bool = false
}
