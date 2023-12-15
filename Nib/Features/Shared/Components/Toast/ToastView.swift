//
//  ToastView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-14.
//

import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
      HStack(alignment: .center, spacing: 12) {
        Image(systemName: style.iconFileName)
          .foregroundColor(style.themeColor)
        Text(message)
          .font(Font.caption)
          .foregroundColor(Color("toastForeground"))
        
        Spacer(minLength: 10)
        
        Button {
          onCancelTapped()
        } label: {
          Image(systemName: "xmark")
            .foregroundColor(style.themeColor)
        }
      }
      .padding()
      .frame(minWidth: 0, maxWidth: width)
      .background(Color("toastBackground"))
      .cornerRadius(8)
      .padding(.horizontal, 16)
    }
}

#Preview {
    ToastView(
        style: .success,
        message: "Success",
        onCancelTapped: { }
    )
}
