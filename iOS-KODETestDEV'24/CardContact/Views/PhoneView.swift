//
//  PhoneView.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class PhoneView: UIView {
    
    let numberLabel = UILabel()
    let phoneImageView = UIImageView()
    var tapPhoneHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(numberLabel)
        addSubview(phoneImageView)
        backgroundColor = .white
        configureProfilePhoneNumberLabel()
        configureProfilePhoneImage()
        
        phoneImageView.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            phoneImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            phoneImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            phoneImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            numberLabel.centerYAnchor.constraint(equalTo: phoneImageView.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: phoneImageView.trailingAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureProfilePhoneNumberLabel() {
        numberLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        numberLabel.font = UIFont(name: "Inter-Medium", size: 16)
        numberLabel.isUserInteractionEnabled = true
        numberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneIconTapped)))
    }
    
    private func configureProfilePhoneImage() {
        phoneImageView.clipsToBounds = true
        phoneImageView.contentMode = .scaleAspectFill
        phoneImageView.image = UIImage(named: "phone")
        phoneImageView.isUserInteractionEnabled = true
        phoneImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneIconTapped)))
    }
    
    @objc private func phoneIconTapped() {
        tapPhoneHandler?()
    }
    
}
