//
//  StorageWithCDManager.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.01.22.
//

import Foundation
import CoreData

class StorageWithCDManager {
    var moc: NSManagedObjectContext {
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "StorageWithCD")
            container.loadPersistentStores(completionHandler: { (storePersistent, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        let context: NSManagedObjectContext = {
            return persistentContainer.viewContext
        }()
        return context
    }
    func saveNewPack(name: String, set: [TranslateData]) {
        let wordsPack = WordPacks(context: moc)
        let words: NSMutableSet = []
        for item in set {
            let word = Word(context: moc)
            word.words = item.words
            word.translatedWords = item.translatedWords
            word.count = item.count
            word.originLanguage = item.originLanguage
            word.translatedLanguage = item.translatedLanguage
            words.add(word)
        }
        wordsPack.name = name
        wordsPack.addToWord(words)
    }
}
