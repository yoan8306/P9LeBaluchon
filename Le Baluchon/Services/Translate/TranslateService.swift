//
//  TranslateService.swift
//  Le Baluchon
//
//  Created by Yoan on 19/04/2022.
//

import Foundation

class TranslateService {
    static let shared = TranslateService(sessionTask: SessionTask.shared)
    var sessionTask: SessionTaskProtocol
    
    init(sessionTask: SessionTaskProtocol) {
        self.sessionTask = sessionTask
    }
    
    func getTranslation(text: String?, langSource: String, langTarget: String, completionHandler: @escaping (Result <TranslaterDTO, Error>) -> Void) {
        var urlTranslate = URLComponents()
        
        guard let text = text else {
            return
        }
        
        urlTranslate.scheme = "https"
        urlTranslate.host = "translation.googleapis.com"
        urlTranslate.path = "/language/translate/v2"
        urlTranslate.queryItems = [
        URLQueryItem(name: "q", value: text),
        URLQueryItem(name: "source", value: langSource),
        URLQueryItem(name: "target", value: langTarget),
        URLQueryItem(name: "key", value: ApiKeys.translateKey)
        ]
        
        guard let urlTranslate = urlTranslate.url else {
            return
        }
        
        sessionTask.sendTask(url: urlTranslate) { result in
            switch result {
            case .success(let data):
                guard let translatedText = try? JSONDecoder().decode(TranslaterDTO.self, from: data) else {
                    completionHandler(.failure(APIError.decoding))
                    return
                }
                completionHandler(.success(translatedText))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
