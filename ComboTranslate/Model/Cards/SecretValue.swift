//
//  SecretValue.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 12.10.21.
//

import Foundation

struct SecretValue {
    var secretValue: Word?
    var secretValueIndex: Int
    var transDataColection: [Word] = []

    init?(collection: [Word]) {
        self.transDataColection = collection
        guard let randomIndex = Array(0...transDataColection.count-1).randomElement() else {return nil}
        self.secretValueIndex = randomIndex
        self.secretValue = collection[randomIndex]
    }
}
