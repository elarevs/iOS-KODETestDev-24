//
//  ErrorrOfSearch.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class SearchError: UIView {

    private let errorImageView = UIImageView()
    private let errorTitleLabel = UILabel()
    private let errorDescriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(errorImageView)
        addSubview(errorTitleLabel)
        addSubview(errorDescriptionLabel)
        backgroundColor = .white
        setConstraints()
        
        configureErrorImage()
        configureErrorTitleLabel()
        configureErrorDescriptionLabel()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            errorImageView.topAnchor.constraint(equalTo: self.topAnchor),
            errorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 56),
            errorImageView.widthAnchor.constraint(equalToConstant: 56),
            
            errorTitleLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            errorTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            errorDescriptionLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 12),
            errorDescriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    private func configureErrorImage() {
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.clipsToBounds = true
        errorImageView.contentMode = .scaleAspectFill
        errorImageView.image = UIImage(named: "loop")
    }
    
    private func configureErrorTitleLabel() {
        errorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        errorTitleLabel.font = UIFont(name: "Inter-SemiBold", size: 17)
        errorTitleLabel.text = "Мы никого не нашли"
        errorTitleLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
    }
    
    private func configureErrorDescriptionLabel() {
        errorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        errorDescriptionLabel.text = "Попробуй скорректировать запрос"
        errorDescriptionLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        errorDescriptionLabel.font = UIFont(name: "Inter-Regular", size: 16)
    }
    
}
