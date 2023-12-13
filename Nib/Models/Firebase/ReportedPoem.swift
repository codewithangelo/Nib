//
//  ReportedPoem.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import Foundation

enum ReportReason: String, CaseIterable, Identifiable {
    case spam = "spam"
    case sexual = "sexual"
    case hateSpeech = "hate_speech"
    case bullying = "bullying"
    case fakeNews = "fake_news"
    case violent = "violent"
    case selfHarm = "self_harm"
    var id: Self { self }
}

struct ReportedPoem: Codable {
    let poemId: String
    let spam: Int
    let sexual: Int
    let hateSpeech: Int
    let bullying: Int
    let fakeNews: Int
    let violent: Int
    let selfHarm: Int
    
    init(
        poemId: String,
        spam: Int = 0,
        sexual: Int = 0,
        hateSpeech: Int = 0,
        bullying: Int = 0,
        fakeNews: Int = 0,
        violent: Int = 0,
        selfHarm: Int = 0
    ) {
        self.poemId = poemId
        self.spam = spam
        self.sexual = sexual
        self.hateSpeech = hateSpeech
        self.bullying = bullying
        self.fakeNews = fakeNews
        self.violent = violent
        self.selfHarm = selfHarm
    }
    
    enum CodingKeys: String, CodingKey {
        case poemId = "poem_id"
        case spam = "spam"
        case sexual = "sexual"
        case hateSpeech = "hate_speech"
        case bullying = "bullying"
        case fakeNews = "fake_news"
        case violent = "violent"
        case selfHarm = "self_harm"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.poemId = try container.decode(String.self, forKey: .poemId)
        self.spam = try container.decode(Int.self, forKey: .spam)
        self.sexual = try container.decode(Int.self, forKey: .sexual)
        self.hateSpeech = try container.decode(Int.self, forKey: .hateSpeech)
        self.bullying = try container.decode(Int.self, forKey: .bullying)
        self.fakeNews = try container.decode(Int.self, forKey: .fakeNews)
        self.violent = try container.decode(Int.self, forKey: .violent)
        self.selfHarm = try container.decode(Int.self, forKey: .selfHarm)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.poemId, forKey: .poemId)
        try container.encode(self.spam, forKey: .spam)
        try container.encode(self.sexual, forKey: .sexual)
        try container.encode(self.hateSpeech, forKey: .hateSpeech)
        try container.encode(self.bullying, forKey: .bullying)
        try container.encode(self.fakeNews, forKey: .fakeNews)
        try container.encode(self.violent, forKey: .violent)
        try container.encode(self.selfHarm, forKey: .selfHarm)
    }
}
