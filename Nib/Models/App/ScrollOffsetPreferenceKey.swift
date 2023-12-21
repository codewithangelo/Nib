//
//  ScrollOffsetPreferenceKey.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-21.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}
