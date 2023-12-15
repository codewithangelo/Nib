//
//  ExtendView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-14.
//

import SwiftUI

extension View {

  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
