//
//  TranslateData.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 16.09.21.
//

import Foundation

struct TranslateData: Encodable {
    
    var words: String
    var translatedWords: String = ""
    var command: String = ""
    var originLanguage: String
    var translatedLanguage: String
    var count: Float = 0
    init(words: String, translatedWords: String, originLanguage: String, translatedLanguage: String, count: Float) {
        self.words = words
        self.translatedWords = translatedWords
        self.originLanguage = originLanguage
        self.translatedLanguage = translatedLanguage
        self.count = count
    }
    init(words: String, from: String, to: String) {
        self.words = words
        self.originLanguage = from
        self.translatedLanguage = to
    }
    enum CodingKeys: String, CodingKey {
        case words = "text"
        case command = "model_id"
    }
}

struct TranslateListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case translation
    }
    let translation: String
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.translation = try container.decode(String.self, forKey: CodingKeys.translation)
    }
}

struct TranslateResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case translations
        case wordCount = "word_count"
        case characterCount = "character_count"
    }
    var translations: [String] = []
    let wordCount: Int?
    let characterCount: Int?
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let translationsContainer = try container.decode([TranslateListResponse].self, forKey: .translations)
        for element in translationsContainer {
            self.translations.append(element.translation)
        }
        self.wordCount = try container.decode(Int.self, forKey: .wordCount)
        self.characterCount = try container.decode(Int.self, forKey: .characterCount)
    }
}
