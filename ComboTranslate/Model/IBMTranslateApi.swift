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

enum Languages: String {
    case ar
    case eu
    case bn
    case bs
    case bg
    case ca
    case zh
    case zhTW = "zh-TW"
    case hr
    case cs
    case da
    case nl
    case en
    case et
    case fi
    case fr
    case de
    case el
    case gu
    case he
    case hi
    case hu
    case ga
    case id
    case it
    case ja = "Ja"
    case ko
    case lv
    case lt
    case ms
    case ml
    case mt
    case cnr
    case ne
    case nb
    case pl
    case pt
    case ro
    case ru
    case sr
    case si
    case sk
    case sl
    case es
    case sv
    case ta
    case te
    case th
    case tr
    case uk
    case ur
    case vi
    case cy
}

//protocol IBMTranslateApiProtocol {
//    typealias CompletionHandler = (_ success: TranslateData) -> Void
//    var url: URL {get}
//    var authorization: String {get}
//    var contentType: String {get}
//    func translate (data: inout TranslateData, completionHandler: @escaping CompletionHandler)
//}
class IBMTranslateApi {
    
    var languages: [String: Languages] = ["Арабский": .ar, "Баскский": .eu, "Бенгальский": .bn, "Боснийский": .bs, "Балгарский": .bg, "Каталанский": .ca, "Китайский (Упрощенный)": .zh, "Китайский (Традиционный)": .zhTW, "Хорватский": .hr, "Чешский": .cs, "Датский": .da, "Нидерландский": .nl, "Английский": .en, "Эстонский": .et, "Финский": .fi, "Французский": .fr, "Немецкий": .de, "Греческий": .el, "Гуджарати": .gu, "Иврит": .he, "Хинди": .hi, "Венгерский": .hu, "Ирландский": .ga, "Индонезийский": .id, "Итальянский": .it, "Японский": .ja, "Корейский": .ko, "Латвийский": .lv, "Литовский": .lt, "Малайский": .ms, "Малаялам": .ml, "Мальтийский": .mt, "Черногорский": .cnr, "Непальский": .ne, "Бу́кмол": .nb, "Польский": .pl, "Португальский": .pt, "Румынский": .ro, "Русский": .ru, "Сербский": .sr, "Сингальский": .si, "Словацкий": .sk, "Словенский": .sl, "Испанский": .es, "Шведский": .sv, "Тамильский": .ta, "Телугу": .te, "Тайский": .th, "Турецкий": .tr, "Украинский": .uk, "Урду": .ur, "Вьетнамский": .vi, "Валийский": .cy]
    
    typealias CompletionHandler = (_ success: TranslateData) -> Void
    
    //    let apiKey = "apikey:ZBwqT-kVBUaH9h_smVsttKcN0IqFQLsxqzxMXSYhkL_q"
//    let url = URL(string: "https://api.eu-gb.language-translator.watson.cloud.ibm.com/instances/5833f11f-0054-4a7a-bd00-d005efb4f6f9/v3/translate?version=2018-05-01")
//    var authorization: String {
//        return "Basic \(apiKey.toBase64())"
//    }
    
//    struct DataForRequest: Encodable {
//        var data: TranslateData
//    }
    
//    func translate(data: TranslateData) -> () -> TranslateData {
//
//        var outputData = data
//        func completionHandler() -> TranslateData {
//            return outputData
//        }
//        let contentType: String = "application/json"
//        let headers: HTTPHeaders = [
//            "Authorization": authorization,
//            "Content-Type": contentType
//            ]
//        AF.request(url!,
//                   method: .post,
//                   parameters: data,
//                   encoder: URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase)),
//                   headers: headers
//        ).responseData { response in
//            switch response.result {
//            case .success(let value):
//                do {
//                    print(try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers))
//                } catch {
//                    print("ошибка извлечения")
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//        return completionHandler
//    }
    enum ResponseProperties: String {
        case apikey
        case text
        case modelId = "model_id"
        case authorization = "Authorization"
        case url = "https://api.eu-gb.language-translator.watson.cloud.ibm.com/instances/5833f11f-0054-4a7a-bd00-d005efb4f6f9/v3/translate?version=2018-05-01"
        case contentType = "Content-Type"
    }
    let url = URL(string: ResponseProperties.url.rawValue)!
    let apiKey: String  = "apikey:ZBwqT-kVBUaH9h_smVsttKcN0IqFQLsxqzxMXSYhkL_q"
    var authorization: String {
        return "Basic \(apiKey.toBase64())"
    }
    let contentType: String = "application/json"
    
    func translate(data: inout TranslateData, completionHandler: @escaping CompletionHandler) {
        var outputData: TranslateData = data
        executeGerRequest(data: outputData) { data in
            guard let data = data else {return}
            do {
                outputData.translatedWords = try JSONDecoder().decode(TranslateResponse.self, from: data).translations
                completionHandler(outputData)
            } catch {}
        }
    }
    func executeGerRequest(data: TranslateData, completionHandler: @escaping (Data?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(authorization, forHTTPHeaderField: ResponseProperties.authorization.rawValue)
        request.addValue(contentType, forHTTPHeaderField: ResponseProperties.contentType.rawValue)
        request.httpBody = try? JSONEncoder().encode(data as TranslateData)
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error)
            } else {
                completionHandler(data)
            }
        }.resume()
    }
}
