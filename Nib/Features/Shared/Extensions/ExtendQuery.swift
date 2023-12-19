//
//  ExtendQuery.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-18.
//

import FirebaseFirestore
import Foundation

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).documents
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (documents: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let documents = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (documents, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
}
