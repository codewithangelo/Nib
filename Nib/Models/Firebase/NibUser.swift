//
//  NibUser.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

import Foundation

struct NibUser: Codable, Equatable {
    let userId: String
    let email: String?
    let createdAt: Date?
    let displayName: String?
    
    init(
        userId: String,
        email: String? = nil,
        createdAt: Date? = nil,
        displayName: String? = nil
    )  {
        self.userId = userId
        self.email = email
        self.createdAt = createdAt
        self.displayName = displayName
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case createdAt = "created_at"
        case displayName = "display_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.createdAt, forKey: .createdAt)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
    }
    
    static func ==(lhs: NibUser, rhs: NibUser) -> Bool {
        return lhs.userId == rhs.userId
    }
}
