//
//  e.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation

extension Contact {
    var currentBirth: Date? {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentYear = Calendar.current.component(.year, from: currentDate)
        let contactBirthdayComponents = Calendar.current.dateComponents([.month, .day], from: dateFormatter.date(from: birthday)!)
        var contactNextBirthdayComponents = DateComponents()
        contactNextBirthdayComponents.year = currentYear
        contactNextBirthdayComponents.month = contactBirthdayComponents.month
        contactNextBirthdayComponents.day = contactBirthdayComponents.day
        if let nextBirthdayDate = Calendar.current.date(from: contactNextBirthdayComponents) {
            if nextBirthdayDate < currentDate {
                contactNextBirthdayComponents.year! += 1
            }
            return Calendar.current.date(from: contactNextBirthdayComponents)
        }
        return nil
    }
}
