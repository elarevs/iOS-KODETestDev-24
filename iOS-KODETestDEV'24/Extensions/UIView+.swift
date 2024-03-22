//
//  UIView+.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import UIKit

extension UIView {
    func addSubviews(views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}
