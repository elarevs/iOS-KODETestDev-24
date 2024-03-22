//
//  ContactModel.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

// MARK: - Item
struct Contact: Codable, Comparable {
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        if lhs.lastName != rhs.lastName {
            return lhs.lastName < rhs.lastName
        } else {
            return lhs.firstName < rhs.firstName
        }
    }

    let id: String
    let avatarUrl: String
    let firstName, lastName, userTag: String
    let department: Departments
    let position, birthday, phone: String
        
}

// MARK: - ItemsQuery
struct ContactsQuery: Codable {
    let items: [Contact]
}
