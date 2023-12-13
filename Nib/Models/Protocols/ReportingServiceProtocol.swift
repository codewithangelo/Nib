//
//  ReportingServiceProtocol.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import Foundation

protocol ReportingServiceProtocol {
    @discardableResult
    func getReportedPoem(poemId: String) async throws -> ReportedPoem?

    func createReportedPoem(poemId: String) async throws
    
    func reportPoem(poemId: String, reason: ReportReason) async throws
}
