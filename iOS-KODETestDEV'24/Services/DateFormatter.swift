//
//  DateFormatter.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class DateFormat {
    
    static func formatDate(_ dateString: String, fromFormat: String, toFormat: String, localeIdentifier: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        dateFormatter.dateFormat = fromFormat
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    
    static func calculateAgeFromDate(_ dateString: String, format: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let birthDate = dateFormatter.date(from: dateString) else {
            return 0
        }
        guard let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year else {
            return 0
        }
        return age
    }
    
}
