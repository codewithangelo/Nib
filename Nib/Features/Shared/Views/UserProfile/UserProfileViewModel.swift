//
//  UserProfileViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-17.
//

import Foundation

@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published
    var selectedPoem: Poem? = nil
}
