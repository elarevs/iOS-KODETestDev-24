//
//  DateOfBirthView.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class DateOfBirthView: UIView {
    
    let dateOfBirthLabel = UILabel()
    let ageLabel = UILabel()
    let starImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(dateOfBirthLabel)
        addSubview(ageLabel)
        addSubview(starImageView)
        backgroundColor = .white
        
        configureDateOfBirthLabel()
        configureAgeLabel()
        configureStarImageView()
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            starImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            starImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            dateOfBirthLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 12),
            
            ageLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureDateOfBirthLabel() {
        dateOfBirthLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        dateOfBirthLabel.font = UIFont(name: "Inter-Medium", size: 16)
    }
    
    private func configureAgeLabel() {
        ageLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        ageLabel.font = UIFont(name: "Inter-Medium", size: 16)
    }
    
    private func configureStarImageView() {
        starImageView.clipsToBounds = true
        starImageView.contentMode = .scaleAspectFill
        starImageView.image = UIImage(named: "star")
    }
    
}
