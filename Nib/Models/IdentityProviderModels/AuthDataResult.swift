//
//  AuthDataResult.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import FirebaseAuth
import Foundation

struct AuthDataResult {
    let uid: String;
    let email: String?
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
    }
}
