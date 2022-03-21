//
//  WordPack+CoreDataProperties.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 4.03.22.
//
//

import Foundation
import CoreData

extension WordPack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordPack> {
        return NSFetchRequest<WordPack>(entityName: "WordPack")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Double
    @NSManaged public var words: NSSet?
    
    var progress: Float {
        var resultValue: Float = 0
        guard let words = self.words?.allObjects as? [Word] else { return  resultValue }
        for word in words {
            resultValue += word.count
        }
        return resultValue / Float(words.count)
    }

}

// MARK: Generated accessors for words
extension WordPack {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}

extension WordPack: Identifiable {
}
