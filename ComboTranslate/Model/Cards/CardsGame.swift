//
//  CardsGame.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 12.10.21.
//

import Foundation

class CardsGame {
    var secretValue: TranslateData
    var transDataCollection: [TranslateData]
    var uniqueRandValues: [SecretValue] = []
    var secretValueIndex: Int
    var isGameWin: Bool = false {
        didSet {
            if isGameWin {
                secretValue.count += 0.25
            } else if secretValue.count > 0 {
                secretValue.count -= 0.25
            }
        }
    }
    var closure: (CardsGame) -> Void
    init(collection: [TranslateData], value: SecretValue, closure: @escaping (CardsGame) -> Void) {
        self.closure = closure
        self.transDataCollection = collection
        self.secretValue = value.secretValue!
        self.secretValueIndex = value.secretValueIndex
    }
//    func checkTranslate(userValue: TranslateData) -> Bool {
//        if userValue.words == secretValue.words {
//            return true
//        } else {
//            return false
//        }
//    }
    func getNewSecretValue() -> TranslateData? {
        let uniqueValuesCount = uniqueRandValues.count
        while uniqueRandValues.count <= uniqueValuesCount {
            let newSecretValue = SecretValue(collection: transDataCollection)!
            guard newSecretValue.secretValue?.words != secretValue.words else { continue }
            let coinsidenceCount = uniqueRandValues.filter({ value in
                return value.secretValue?.words == newSecretValue.secretValue?.words
            }).count
            if coinsidenceCount < 1 {
                uniqueRandValues.append(newSecretValue)
            }
        }
        return uniqueRandValues.last?.secretValue
    }
}
