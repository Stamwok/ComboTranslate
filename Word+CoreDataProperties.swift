//
//  Word+CoreDataProperties.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 16.02.22.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var count: Float
    @NSManaged public var translatedWords: String?
    @NSManaged public var words: String?
    @NSManaged public var originLanguage: String?
    @NSManaged public var translatedLanguage: String?
    @NSManaged public var wordPacks: NSSet?

}

// MARK: Generated accessors for wordPacks
extension Word {

    @objc(addWordPacksObject:)
    @NSManaged public func addToWordPacks(_ value: WordPacks)

    @objc(removeWordPacksObject:)
    @NSManaged public func removeFromWordPacks(_ value: WordPacks)

    @objc(addWordPacks:)
    @NSManaged public func addToWordPacks(_ values: NSSet)

    @objc(removeWordPacks:)
    @NSManaged public func removeFromWordPacks(_ values: NSSet)

}

extension Word: Identifiable {

}
