//
//  ReportingService.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import FirebaseFirestore
import Foundation

final class ReportingService: ReportingServiceProtocol {    
    private let reportedPoemsCollection = Firestore.firestore().collection("reported_poems")
    
    private func getReportedPoemDocument(poemId: String) -> DocumentReference {
        reportedPoemsCollection.document(poemId)
    }
    
    @discardableResult
    func getReportedPoem(poemId: String) async throws -> ReportedPoem? {
        try await getReportedPoemDocument(poemId: poemId).getDocument(as: ReportedPoem.self)
    }

    func createReportedPoem(poemId: String) async throws {
        let newReportedPoem = ReportedPoem(poemId: poemId)
        try getReportedPoemDocument(poemId: poemId).setData(from: newReportedPoem)
    }
    
    func reportPoem(poemId: String, reason: ReportReason) async throws {
        let reportedPoemDocRef = getReportedPoemDocument(poemId: poemId)
        
        try await reportedPoemDocRef.updateData([
            reason.rawValue: FieldValue.increment(Int64(1))
        ])
    }
}
