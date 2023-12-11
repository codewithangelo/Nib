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
    
    func getPoemsByAuthorId(authorId: String, count: Int, lastDocument: DocumentSnapshot?) async throws -> (poems: [Poem], lastDocument: DocumentSnapshot?)
}
