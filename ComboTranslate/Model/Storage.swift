//
//  File.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.09.21.
//

import Foundation

protocol StorageProtocol {
    func saveData(translateDataCollection: [TranslateData])
    func loadData() -> [TranslateData]
}

class Storage {
    private var storage = UserDefaults.standard
    let storageKey = "TranslateData"
    enum TranslateDataKey: String {
        case words
        case translatedWords
        case command
        case count
        case position
    }
    func loadData() -> [TranslateData] {
        var resultDict: [TranslateData] = []
        let dictFromStorage = storage.array(forKey: storageKey) as? [[String: Any]] ?? []
        for elem in dictFromStorage {
            let words = elem[TranslateDataKey.words.rawValue]!
            let translatedWords = elem[TranslateDataKey.translatedWords.rawValue]!
            let command = elem[TranslateDataKey.command.rawValue]!
            let count = elem[TranslateDataKey.count.rawValue]!
            resultDict.append(TranslateData(words: words as! [String], translatedWords: translatedWords as! [String], command: command as! String, count: count as! Float))
        }
        return resultDict
    }
    
    func saveData(data: [TranslateData]) {
        var dictForStorage: [[String: Any]] = []
        data.forEach { elem in
            var elemForStorage: [String: Any] = [:]
            elemForStorage[TranslateDataKey.words.rawValue] = elem.words
            elemForStorage[TranslateDataKey.translatedWords.rawValue] = elem.translatedWords
            elemForStorage[TranslateDataKey.command.rawValue] = elem.command
            elemForStorage[TranslateDataKey.count.rawValue] = elem.count
            dictForStorage.append(elemForStorage)
        }
        storage.set(dictForStorage, forKey: storageKey)
    }
    
//    func loadDataForCards(number:Int) -> [TranslateData] {
//        let resultDict: [TranslateData] = []
//        let dictFromStorage = storage.array(forKey: storageKey) as? [[String: Any]] ?? []
//        var randomIndex: Int {
//            return Array(0...dictFromStorage.count - 1).randomElement()!
//        }
//
//        return
//    }
}
