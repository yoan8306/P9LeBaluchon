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
}
