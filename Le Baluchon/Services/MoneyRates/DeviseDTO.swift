//
//  Devise.swift
//  Le Baluchon
//
//  Created by Yoan on 28/03/2022.
//

import Foundation

struct DeviseDTO: Decodable {
    var timestamp: Int
    var rates: [String: Float]
}
