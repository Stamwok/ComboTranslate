//
//  String+Base64.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 18.02.22.
//

import Foundation

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
