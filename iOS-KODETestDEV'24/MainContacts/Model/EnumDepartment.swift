//
//  EnumDepartment.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation

enum Departments: String, Codable, CaseIterable {
    case all
    case android
    case ios
    case design
    case management
    case qa
    case back_office
    case frontend
    case hr
    case pr
    case backend
    case support
    case analytics
    
    var title: String {
        switch self {
        case .all:
            return "Все"
        case .android:
            return "Android"
        case .ios:
            return "iOS"
        case .design:
            return "Дизайн"
        case .management:
            return "Менеджмент"
        case .qa:
            return "QA"
        case .back_office:
            return "Бэк-офис"
        case .frontend:
            return "Frontend"
        case .hr:
            return "HR"
        case .pr:
            return "PR"
        case .backend:
            return "Backend"
        case .support:
            return "Техподдержка"
        case .analytics:
            return "Аналитика"
        }
    }
}
