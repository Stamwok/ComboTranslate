//
//  Words+CoreDataProperties.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 26.01.22.
//
//

import Foundation
import CoreData


extension Words {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Words> {
        return NSFetchRequest<Words>(entityName: "Words")
    }

    @NSManaged public var words: String?
    @NSManaged public var translatedWords: String?
    @NSManaged public var originLanguage: String?
    @NSManaged public var translatedLanguage: String?
    @NSManaged public var count: Float

}

extension Words : Identifiable {

}
