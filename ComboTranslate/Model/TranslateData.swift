//
//  TranslateData.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 16.09.21.
//

import Foundation

struct TranslateData: Encodable {
    
    var word: String
    var translatedWord: String = ""
    var command: String = ""
    var originLanguage: String = ""
    var translationLanguage: String = ""
//    var count: Float = 0
//    init(word: String, translatedWord: String, originLanguage: String, translationLanguage: String, count: Float) {
//        self.word = word
//        self.translatedWord = translatedWord
//        self.originLanguage = originLanguage
//        self.translationLanguage = translationLanguage
//        self.count = count
//    }
    init(word: String, from originLanguage: String, to translationLanguage: String) {
        self.word = word
//        self.command = "\(originLanguage)-\(translationLanguage)"
        self.originLanguage = originLanguage
        self.translationLanguage = translationLanguage
    }
    enum CodingKeys: String, CodingKey {
        case word = "text"
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
