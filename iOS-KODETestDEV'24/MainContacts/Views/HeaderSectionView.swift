//
//  HeaderSectionView.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

class HeaderSectionView: UIView {
    
    private let leftLineView = UIView()
    private let rightLineView = UIView()
    let yearLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        addSubview(yearLabel)
        addSubview(leftLineView)
        addSubview(rightLineView)
        
        configureYearLabel()
        configureLeftLine()
        configureRightLine()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: self.topAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            yearLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            leftLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftLineView.trailingAnchor.constraint(equalTo: yearLabel.leadingAnchor, constant: -12),
            leftLineView.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor),
            leftLineView.widthAnchor.constraint(equalToConstant: 72),
            leftLineView.heightAnchor.constraint(equalToConstant: 1),
            
            rightLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightLineView.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 12),
            rightLineView.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor),
            rightLineView.widthAnchor.constraint(equalToConstant: 72),
            rightLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func configureYearLabel() {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.text = ""
        yearLabel.font = UIFont(name: "Inter-Medium", size: 15)
        yearLabel.textColor = UIColor(red: 0.765, green: 0.765, blue: 0.776, alpha: 1)
        yearLabel.textAlignment = .center
    }
    
    private func configureLeftLine() {
        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        leftLineView.backgroundColor = UIColor(red: 0.76, green: 0.76, blue: 0.78, alpha: 1)
    }
    
    private func configureRightLine() {
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        rightLineView.backgroundColor = UIColor(red: 0.76, green: 0.76, blue: 0.78, alpha: 1)
    }
    
}
