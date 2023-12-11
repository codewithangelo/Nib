//
//  Username.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

struct Username: Codable, Equatable {
    let userId: String
    let username: String
    
    init(
        userId: String,
        username: String
    ) {
        self.userId = userId
        self.username = username
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username = "username"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.username = try container.decode(String.self, forKey: .username)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.username, forKey: .username)
    }
    
    static func ==(lhs: Username, rhs: Username) -> Bool {
        return lhs.userId == rhs.userId && lhs.username == rhs.username
    }
}
