//
//  PoemServiceProtocol.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import FirebaseFirestore
import Foundation

protocol PoemServiceProtocol {
    func createPoem(poem: Poem) async throws
    
    func updatePoem(poem: Poem) async throws
    
    func getPoem(poemId: String) async throws -> Poem?
    
    func deletePoem(poemId: String) async throws
    
    func getPoems(count: Int, lastDocument: DocumentSnapshot?, authorId: String?) async throws -> (documents: [Poem], lastDocument: DocumentSnapshot?)
    
    func getPoemAuthorName(authorId: String) async throws -> Username?
}
