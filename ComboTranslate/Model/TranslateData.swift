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
    let format: String = "text"
    var originLanguage: String
    var translationLanguage: String
    var source: String = ""
    var target: String = ""
//    var key: String = ""
    init(word: String, from originLanguage: String, to translationLanguage: String) {
        self.word = word
        self.originLanguage = originLanguage
        self.translationLanguage = translationLanguage
    }
    enum CodingKeys: String, CodingKey {
        case word = "q"
        case source = "source"
        case target = "target"
        case format = "format"
//        case key = "key"
    }
}

 // MARK: - decode response with languages
struct LanguageList: Decodable {
    let languages: [Language]
}

struct Language: Decodable {
    let language: String
}

struct GetLanguagesResponse: Decodable {
    let data: LanguageList
}

// MARK: - decode response with translation
struct TranslatedText: Decodable {
    let translatedText: String
}

struct Translations: Decodable {
    let translations: [TranslatedText]
}

struct TranslateResponse: Decodable {
    let data: Translations
}
