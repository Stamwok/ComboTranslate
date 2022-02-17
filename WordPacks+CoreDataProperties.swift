//
//  WordPacks+CoreDataProperties.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 16.02.22.
//
//

import Foundation
import CoreData


extension WordPacks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordPacks> {
        return NSFetchRequest<WordPacks>(entityName: "WordPacks")
    }

    @NSManaged public var name: String?
    @NSManaged public var word: NSSet?

}

// MARK: Generated accessors for word
extension WordPacks {

    @objc(addWordObject:)
    @NSManaged public func addToWord(_ value: Word)

    @objc(removeWordObject:)
    @NSManaged public func removeFromWord(_ value: Word)

    @objc(addWord:)
    @NSManaged public func addToWord(_ values: NSSet)

    @objc(removeWord:)
    @NSManaged public func removeFromWord(_ values: NSSet)

}

extension WordPacks: Identifiable {

}
