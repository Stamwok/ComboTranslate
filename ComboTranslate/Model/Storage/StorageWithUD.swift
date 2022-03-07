//
//  File.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.09.21.
//

import Foundation

class Storage {
    private var storage = UserDefaults.standard
    let storageKey = "TranslateData"
    enum TranslateDataKey: String {
        case words
        case translatedWords
        case originLanguage
        case translatedLanguage
        case count
    }
    
    // MARK: languages data
    enum LanguageDataKeys: String {
        case originLanguage
        case translatedLanguage
    }
    
    func saveOriginLanguage(_ originLanguage: String) {
        let dataForStorage: String? = originLanguage
        storage.setValue(dataForStorage, forKey: LanguageDataKeys.originLanguage.rawValue)
    }
    func loadOriginLanguage() -> String {
        let dataFromStorage = storage.string(forKey: LanguageDataKeys.originLanguage.rawValue)
        return dataFromStorage ?? "Английский"
    }
    
    func saveTranslatedLanguage(_ translatedLanguage: String) {
        let dataForStorage: String? = translatedLanguage
        storage.setValue(dataForStorage, forKey: LanguageDataKeys.translatedLanguage.rawValue)
    }
    func loadTranslatedLanguage() -> String {
        let dataFromStorage = storage.string(forKey: LanguageDataKeys.translatedLanguage.rawValue)
        return dataFromStorage ?? "Русский"
    }
}
