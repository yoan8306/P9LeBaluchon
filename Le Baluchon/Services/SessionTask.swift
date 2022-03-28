//
//  SessionTask.swift
//  Le Baluchon
//
//  Created by Yoan on 21/03/2022.
//

import Foundation

final class SessionTask {
    static let shared = SessionTask()
    private init() {}

    func sendTask(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(error ?? APIError.noData))
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(APIError.statusCodeInvalid))
                    return
                }
                completion(.success(data))
            }
        }).resume()

    }
}