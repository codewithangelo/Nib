//
//  HomeView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-16.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            PoemFeedView(hasVisitAuthorMenuButton: true)
        }
    }
}

#Preview {
    HomeView()
}
