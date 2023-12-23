//
//  FavoritePoem.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-22.
//

import Foundation

struct FavoritePoem: Codable {
    let id: String
    let userId: String
    let poemId: String
    
    init(
        userId: String,
        poemId: String
    ) {
        self.id = "\(userId)\(poemId)"
        self.userId = userId
        self.poemId = poemId
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case poemId = "poem_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.poemId = try container.decode(String.self, forKey: .poemId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.poemId, forKey: .poemId)
    }
}
