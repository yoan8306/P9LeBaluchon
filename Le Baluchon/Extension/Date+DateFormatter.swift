//
//  Date+DateFormatter.swift
//  Le Baluchon
//
//  Created by Yoan on 28/03/2022.
//

import Foundation

extension Date {
    func toFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
