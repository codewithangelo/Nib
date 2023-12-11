//
//  UserServiceProtocol.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

protocol UserServiceProtocol {
    func createNewUser(user: User) async throws
    
    func getUser(userId: String) async throws -> User?
    
    func deleteUser(user: User) async throws
    
    func updateUsername(oldUsername: Username, newUsername: Username) async throws
}
