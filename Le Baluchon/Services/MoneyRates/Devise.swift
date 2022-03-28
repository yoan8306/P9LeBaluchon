//
//  Devise.swift
//  Le Baluchon
//
//  Created by Yoan on 28/03/2022.
//

import Foundation

struct Devise: Decodable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Float]
}
