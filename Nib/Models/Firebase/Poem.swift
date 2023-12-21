//
//  Poem.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import Foundation

struct Poem: Identifiable, Codable, Equatable, Hashable {
    let authorId: String
    let content: String
    let createdAt: Date?
    let id: String?
    let modifiedAt: Date?
    let title: String
    let likeCount: Int?
    
    init(
        authorId: String,
        content: String,
        createdAt: Date? = nil,
        id: String? = nil,
        modifiedAt: Date? = nil,
        title: String,
        likeCount: Int? = nil
    ) {
        self.authorId = authorId
        self.content = content
        self.createdAt = createdAt
        self.id = id
        self.modifiedAt = modifiedAt
        self.title = title
        self.likeCount = likeCount
    }
    
    enum CodingKeys: String, CodingKey {
        case authorId = "author_id"
        case createdAt = "created_at"
        case content = "content"
        case id = "id"
        case modifiedAt = "modified_at"
        case title = "title"
        case likeCount = "like_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.authorId = try container.decode(String.self, forKey: .authorId)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.content = try container.decode(String.self, forKey: .content)
        self.id = try container.decode(String.self, forKey: .id)
        self.modifiedAt = try container.decodeIfPresent(Date.self, forKey: .modifiedAt)
        self.title = try container.decode(String.self, forKey: .title)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.authorId, forKey: .authorId)
        try container.encodeIfPresent(self.createdAt, forKey: .createdAt)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.modifiedAt, forKey: .modifiedAt)
        try container.encode(self.title, forKey: .title)
        try container.encodeIfPresent(self.likeCount, forKey: .likeCount)
    }
    
    static func ==(lhs: Poem, rhs: Poem) -> Bool {
        return lhs.id == rhs.id
    }
}

