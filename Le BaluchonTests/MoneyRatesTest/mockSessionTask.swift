//
//  mockSessionTask.swift
//  Le BaluchonTests
//
//  Created by Yoan on 31/03/2022.
//

import Foundation
@testable import Le_Baluchon

class SessionTaskMock: SessionTaskProtocol {
    var data: Data?
    var responseError: Error?

    func sendTask(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let data = data {
            completion(.success(data))
        } else if let responseError = responseError {
            completion(.failure(responseError))
        }
    }
}
