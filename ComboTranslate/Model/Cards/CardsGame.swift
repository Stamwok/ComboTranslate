//
//  CardsGame.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 12.10.21.
//

import Foundation

final class CardsGame {
    var secretValue: Word
    private var transDataCollection: [Word]
    private var uniqueRandValues: [SecretValue] = []
    private var secretValueIndex: Int
    var isGameWin: Bool = false {
        didSet {
            if isGameWin {
                secretValue.count += 0.25
            } else if secretValue.count > 0 {
                secretValue.count -= 0.25
            }
            secretValue.lastChanges = Date()
        }
        
    }
    var closure: (CardsGame) -> Void
    init(collection: [Word], value: SecretValue, closure: @escaping (CardsGame) -> Void) {
        self.closure = closure
        self.transDataCollection = collection
        self.secretValue = value.secretValue!
        self.secretValueIndex = value.secretValueIndex
    }
    func getNewSecretValue() -> Word? {
        let uniqueValuesCount = uniqueRandValues.count
        while uniqueRandValues.count <= uniqueValuesCount {
            let newSecretValue = SecretValue(collection: transDataCollection)!
            guard newSecretValue.secretValue?.word != secretValue.word else { continue }
            let coinsidenceCount = uniqueRandValues.filter({ value in
                return value.secretValue?.word == newSecretValue.secretValue?.word
            }).count
            if coinsidenceCount < 1 {
                uniqueRandValues.append(newSecretValue)
            }
        }
        return uniqueRandValues.last?.secretValue
    }
}
