//
//  ReportPoemViewModel.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-12.
//

import Foundation

@MainActor
final class ReportPoemViewModel: ObservableObject {
    @Published
    var reason: ReportReason = .spam
    
    private let reportingService: ReportingServiceProtocol
    
    init(reportingService: ReportingServiceProtocol) {
        self.reportingService = reportingService
    }
    
    func confirmReport(poemId: String) async throws {
        do {
            try await reportingService.getReportedPoem(poemId: poemId)
        } catch {
            try await reportingService.createReportedPoem(poemId: poemId)
        }
        
        try await reportingService.reportPoem(poemId: poemId, reason: self.reason)
    }
}
