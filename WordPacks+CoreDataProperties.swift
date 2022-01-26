//
//  WordPacks+CoreDataProperties.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.01.22.
//
//

import Foundation
import CoreData


extension WordPacks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordPacks> {
        return NSFetchRequest<WordPacks>(entityName: "WordPacks")
    }

    @NSManaged public var rowsOfWordPack: NSSet?

}

// MARK: Generated accessors for rowsOfWordPack
extension WordPacks {

    @objc(addRowsOfWordPackObject:)
    @NSManaged public func addToRowsOfWordPack(_ value: RowOfWordPacks)

    @objc(removeRowsOfWordPackObject:)
    @NSManaged public func removeFromRowsOfWordPack(_ value: RowOfWordPacks)

    @objc(addRowsOfWordPack:)
    @NSManaged public func addToRowsOfWordPack(_ values: NSSet)

    @objc(removeRowsOfWordPack:)
    @NSManaged public func removeFromRowsOfWordPack(_ values: NSSet)

}

extension WordPacks : Identifiable {

}
