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
//    let languagesKey = "LanguagesData"
    enum TranslateDataKey: String {
        case words
        case translatedWords
        case originLanguage
        case translatedLanguage
        case count
    }
    
    // MARK: words data
    func loadData() -> [TranslateData] {
        var resultDict: [TranslateData] = []
        let dictFromStorage = storage.array(forKey: storageKey) as? [[String: Any]] ?? []
        for elem in dictFromStorage {
            let words = elem[TranslateDataKey.words.rawValue]!
            let translatedWords = elem[TranslateDataKey.translatedWords.rawValue]!
            let originLanguage = elem[TranslateDataKey.originLanguage.rawValue]!
            let translatedLanguage = elem[TranslateDataKey.translatedWords.rawValue]!
//            let command = elem[TranslateDataKey.command.rawValue]!
            let count = elem[TranslateDataKey.count.rawValue]!
            let dataForDict = TranslateData(words: words as! String, translatedWords: translatedWords as! String, originLanguage: originLanguage as! String, translatedLanguage: translatedLanguage as! String, count: count as! Float)
            resultDict.append(dataForDict)
        }
        return resultDict
    }
    
    func saveData(data: [TranslateData]) {
        var dictForStorage: [[String: Any]] = []
        data.forEach { elem in
            var elemForStorage: [String: Any] = [:]
            elemForStorage[TranslateDataKey.words.rawValue] = elem.words
            elemForStorage[TranslateDataKey.translatedWords.rawValue] = elem.translatedWords
            elemForStorage[TranslateDataKey.originLanguage.rawValue] = elem.originLanguage
            elemForStorage[TranslateDataKey.translatedLanguage.rawValue] = elem.translatedLanguage
//            elemForStorage[TranslateDataKey.command.rawValue] = elem.command
            elemForStorage[TranslateDataKey.count.rawValue] = elem.count
            dictForStorage.append(elemForStorage)
        }
        storage.set(dictForStorage, forKey: storageKey)
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
