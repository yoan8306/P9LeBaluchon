//
//  Devise.swift
//  Le Baluchon
//
//  Created by Yoan on 28/03/2022.
//

import Foundation

struct Devise: Decodable {
    var success: Bool? = false
    var timestamp: Int? = 0
    var base: String?
    var date: String?
    var rates: [String: Float]?
}
