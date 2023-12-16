//
//  ToastModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-14.
//

import Foundation

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 5
    var width: Double = .infinity
}
