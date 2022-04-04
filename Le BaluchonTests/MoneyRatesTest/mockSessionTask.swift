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

//
//
//
//// create a partial mock by subclassing the original class
// class URLSessionDataTaskMock: URLSessionDataTask {
//    private let closure: () -> Void
//
//    convenience init(closure: @escaping () -> Void) {
//        self.init()
//        self.closure = closure
//    }
//    override func resume() {
//        closure()
//    }
// }

// class URLSessionMock: URLSession {
//    var data: Data?
//    var urlResponse: URLResponse?
//    var responseError: Error?
//    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
//
//    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        let data = self.data
//        let urlResponse = self.urlResponse
//        let responseError = self.responseError
//
//        return URLSessionDataTaskMock {
//            completionHandler(data, urlResponse, responseError)
//        }
//    }
// }
//
// class URLSessionDataTaskFake: URLSessionDataTask {
//    var data: Data?
//    var urlResponse: URLResponse?
//    var responseError: Error?
//    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
//
//    override func resume() {
//        completionHandler?(data, urlResponse, responseError)
//    }
// }
