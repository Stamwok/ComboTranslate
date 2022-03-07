//
//  Word+CoreDataProperties.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 4.03.22.
//
//

import Foundation
import CoreData

extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var count: Float
    @NSManaged public var originLanguage: String?
    @NSManaged public var translatedWord: String?
    @NSManaged public var translationLanguage: String?
    @NSManaged public var word: String?
    @NSManaged public var id: Double
    @NSManaged public var wordPacks: NSSet?

}

// MARK: Generated accessors for wordPacks
extension Word {

    @objc(addWordPacksObject:)
    @NSManaged public func addToWordPacks(_ value: WordPack)

    @objc(removeWordPacksObject:)
    @NSManaged public func removeFromWordPacks(_ value: WordPack)

    @objc(addWordPacks:)
    @NSManaged public func addToWordPacks(_ values: NSSet)

    @objc(removeWordPacks:)
    @NSManaged public func removeFromWordPacks(_ values: NSSet)

}

extension Word: Identifiable {
}
