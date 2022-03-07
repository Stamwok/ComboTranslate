//
//  StorageWithCDManager.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.01.22.
//

import Foundation
import CoreData

class StorageWithCDManager {
    
    private init() {}
    
    static let instance = StorageWithCDManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StorageWithCD")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var moc: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveNewPack(name: String, set: [Word]) {
        let wordPack = WordPack(context: moc)
        wordPack.id = setID()
        wordPack.name = name
        wordPack.addToWords(NSSet.init(array: set))
    }
    func addNewWord(word: TranslateData) -> Word {
        let newWord = Word(context: moc)
        newWord.id = setID()
        newWord.count = 0
        newWord.word = word.word
        newWord.translatedWord = word.translatedWord
        newWord.originLanguage = word.originLanguage
        newWord.translationLanguage = word.translationLanguage
        newWord.addToWordPacks(getDefaultPack())
        return newWord
    }
    
    func addNewWord(word: Word) -> Word {
        let newWord = Word(context: moc)
        newWord.id = setID()
        newWord.count = word.count
        newWord.word = word.word
        newWord.translatedWord = word.translatedWord
        newWord.originLanguage = word.originLanguage
        newWord.translationLanguage = word.translationLanguage
        newWord.wordPacks = word.wordPacks
        return newWord
    }
    
    func loadWords() -> [Word] {
        guard let words = try? moc.fetch(Word.fetchRequest()) else { return [] }
        return words
    }
    
    func loadWordPacks() -> [WordPack] {
        guard let packs = try? moc.fetch(WordPack.fetchRequest()) else { return [] }
        return packs
    }
    
    func removeItem (item: Any) {
        if let itemForRemove = item as? Word {
            moc.delete(itemForRemove)
        } else if let itemForRemove = item as? WordPack {
            moc.delete(itemForRemove)
        }
    }
    
    func saveContext() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                moc.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func setID() -> Double {
        return NSDate().timeIntervalSince1970
    }
    
    private func getDefaultPack() -> WordPack {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WordPack")
        request.predicate = NSPredicate(format: "id == 1")
        if let defaultPack = try? moc.fetch(request).first as? WordPack {
            return defaultPack
        } else {
            let defaultPack = WordPack(context: moc)
            defaultPack.id = 1
            defaultPack.name = "Переведенные слова"
            defaultPack.words = []
            return defaultPack
        }
    }
}
