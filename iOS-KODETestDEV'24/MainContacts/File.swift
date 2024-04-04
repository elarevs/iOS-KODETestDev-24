//
//  File.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 27.03.2024.
//

import Foundation
import UIKit

class Car {
    let color: Color
    init(color: Color) {
        self.color = color
    }

    enum Color {
        case red
        case green
        case un
    }

func colorChoose (_ car: Car) -> String? {
    
    switch car.color {
    case .red:
        "Mike like this color"
    case .green:
        "Mike don't like this color"
    case .un:
        nil
    }
}

func printMikeAnswer (car: Car?) {
    print(car.map { color.colorChoose(($0)) } ?? "U C")
}

printMikeAnswer (car: Car (color: . unknown))
