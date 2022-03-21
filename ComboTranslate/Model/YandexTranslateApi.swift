//
//  YandexTranslateApi.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 14.03.22.
//

import Foundation
import Alamofire

class YandexTranslateApi {
    
    typealias CompletionHandler = (_ success: TranslateData) -> Void
    
        let apiKey = "AIzaSyBg1ppjf39zYS6KFMPq60TIddddBIYhs7A"
    let url = URL(string: "https://api.eu-gb.language-translator.watson.cloud.ibm.com/instances/5833f11f-0054-4a7a-bd00-d005efb4f6f9/v3/translate?version=2018-05-01")
    var authorization: String {
        return "Basic \(apiKey.toBase64())"
    }
    
    struct DataForRequest: Encodable {
        var data: TranslateData
    }
    
    func getLanguages(completionHandler: @escaping ([Language]) -> Void) {
        let url = "https://translation.googleapis.com/language/translate/v2/languages?key=\(apiKey)"
        
        AF.request(url,
                   method: .get
        ).responseDecodable(of: GetLanguagesResponse.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.data.languages)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func translate(data: TranslateData, completionHandler: @escaping CompletionHandler) {
        guard let sourceLanguage = YandexLanguagesList.languages[data.originLanguage],
              let targetLanguage = YandexLanguagesList.languages[data.translationLanguage] else { return }
        let url = "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)"
        var outputData = data
        outputData.source = sourceLanguage
        outputData.target = targetLanguage
        AF.request(url,
                   method: .post,
                   parameters: outputData,
                   encoder: JSONParameterEncoder.default
        ).responseDecodable(of: TranslateResponse.self) { response in
            switch response.result {
            case .success(let value):
                outputData.translatedWord = value.data.translations.reduce("", { partialResult, response in
                    return partialResult + response.translatedText
                })
                completionHandler(outputData)
            case .failure(let error):
                outputData.translatedWord = ""
                completionHandler(outputData)
                print(error)
            }
        }
    }
}
