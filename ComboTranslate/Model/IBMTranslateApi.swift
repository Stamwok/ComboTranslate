//
//  TranslateApi.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 14.09.21.
//

import Foundation
import Alamofire

// MARK: - Extensions
extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    func toUtf8() -> String {
        return " "
    }
}

class IBMTranslateApi {
    
    var languages: [String: String] = ["Арабский": "ar", "Баскский": "eu", "Бенгальский": "bn", "Боснийский": "bs", "Балгарский": "bg", "Каталанский": "ca", "Китайский (Упрощенный)": "zh", "Китайский (Традиционный)": "zhTW", "Хорватский": "hr", "Чешский": "cs", "Датский": "da", "Нидерландский": "nl", "Английский": "en", "Эстонский": "et", "Финский": "fi", "Французский": "fr", "Немецкий": "de", "Греческий": "el", "Гуджарати": "gu", "Иврит": "he", "Хинди": "hi", "Венгерский": "hu", "Ирландский": "ga", "Индонезийский": "id", "Итальянский": "it", "Японский": "ja", "Корейский": "ko", "Латвийский": "lv", "Литовский": "lt", "Малайский": "ms", "Малаялам": "ml", "Мальтийский": "mt", "Черногорский": "cnr", "Непальский": "ne", "Бу́кмол": "nb", "Польский": "pl", "Португальский": "pt", "Румынский": "ro", "Русский": "ru", "Сербский": "sr", "Сингальский": "si", "Словацкий": "sk", "Словенский": "sl", "Испанский": "es", "Шведский": "sv", "Тамильский": "ta", "Телугу": "te", "Тайский": "th", "Турецкий": "tr", "Украинский": "uk", "Урду": "ur", "Вьетнамский": "vi", "Валийский": "cy"]
    
    typealias CompletionHandler = (_ success: TranslateData) -> Void
    
        let apiKey = "apikey:ZBwqT-kVBUaH9h_smVsttKcN0IqFQLsxqzxMXSYhkL_q"
    let url = URL(string: "https://api.eu-gb.language-translator.watson.cloud.ibm.com/instances/5833f11f-0054-4a7a-bd00-d005efb4f6f9/v3/translate?version=2018-05-01")
    var authorization: String {
        return "Basic \(apiKey.toBase64())"
    }
    
    struct DataForRequest: Encodable {
        var data: TranslateData
    }
    
    func translate(data: inout TranslateData, completionHandler: @escaping CompletionHandler) {

        var outputData = data
        print(data)
//        print(languages[data.originLanguage]!)
        data.command = "\(languages[data.originLanguage]!)-\(languages[data.translatedLanguage]!)"
        print(data.command)
        let contentType: String = "application/json"
        let headers: HTTPHeaders = [
            "Authorization": authorization,
            "Content-Type": contentType
            ]
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        AF.request(url!,
                   method: .post,
                   parameters: data,
                   encoder: JSONParameterEncoder(encoder: encoder),
                   headers: headers
        ).responseDecodable(of: TranslateResponse.self) { response in
            switch response.result {
            case .success(let value):
                outputData.translatedWords = value.translations.reduce("", +)
                completionHandler(outputData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
