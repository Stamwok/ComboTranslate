//
//  TranslateApi.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 14.09.21.
//

import Foundation
// MARK: - Extensions
extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    func toUtf8() -> String {
        return " "
    }
}

protocol IBMTranslateApiProtocol {
    typealias CompletionHandler = (_ success: TranslateData) -> Void
    var url: URL {get}
    var authorization: String {get}
    var contentType: String {get}
    func translate (data: inout TranslateData, completionHandler: @escaping CompletionHandler)
}
class IBMTranslateApi: IBMTranslateApiProtocol {
    typealias CompletionHandler = (_ success: TranslateData) -> Void
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
