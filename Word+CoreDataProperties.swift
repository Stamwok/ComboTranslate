//
//  Word+CoreDataProperties.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.01.22.
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
    @NSManaged public var translatedLanguage: String?
    @NSManaged public var translatedWords: String?
    @NSManaged public var words: String?

}

extension Word : Identifiable {

}
