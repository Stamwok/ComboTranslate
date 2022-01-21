//
//  TranslateDelegate.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 14.01.22.
//

import Foundation

protocol TranslateViewDelegate: AnyObject {
    func translate(text: String, completionHandler: @escaping (_ translated: TranslateData) -> Void)
    func closeTranslateView()
    func setData(data: TranslateData?)
}

protocol TranslatedViewDelegate: AnyObject {
    func edit()
    func closeTranslatedView()
}
