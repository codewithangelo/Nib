//
//  YourPoemsViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import FirebaseFirestore
import Foundation

@MainActor
final class YourPoemsViewModel: ObservableObject {
    @Published
    var selectedPoem: Poem? = nil
}
