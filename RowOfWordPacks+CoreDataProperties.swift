//
//  RowOfWordPacks+CoreDataProperties.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.01.22.
//
//

import Foundation
import CoreData


extension RowOfWordPacks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RowOfWordPacks> {
        return NSFetchRequest<RowOfWordPacks>(entityName: "RowOfWordPacks")
    }

    @NSManaged public var wordPackName: NSDecimalNumber?
    @NSManaged public var words: NSSet?

}

// MARK: Generated accessors for words
extension RowOfWordPacks {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}

extension RowOfWordPacks : Identifiable {

}
