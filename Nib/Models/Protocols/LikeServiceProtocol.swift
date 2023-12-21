//
//  LikeServiceProtocol.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-20.
//

import Foundation

protocol LikeServiceProtocol {
    func getHasUserLikedPoem(poemId: String, user: User) async throws -> Bool
    
    func getPoemLikeCount(poemId: String) async throws -> Int
    
    func likePoem(poemId: String, user: User) async throws
    
    func unlikePoem(poemId: String, user: User) async throws
}
