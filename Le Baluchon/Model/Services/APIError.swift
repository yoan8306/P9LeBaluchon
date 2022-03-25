//
//  APIError.swift
//  Le Baluchon
//
//  Created by Yoan on 21/03/2022.
//

import Foundation

enum APIError: Error {
    case noData
    case statusCodeInvalid
    case decoding

    var detail: String {
        switch self {
        case .noData:
            return "Error for download data"
        case .statusCodeInvalid:
            return "Status code invalid"
        case .decoding:
            return "Error decoding"
        }
    }
}
