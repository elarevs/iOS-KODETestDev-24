//
//  ErrorOfFatal.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

class FatalError: UIView {

    private let errorImageView = UIImageView()
    private let errorTitleLabel = UILabel()
    private let errorDescriptionLabel = UILabel()
    lazy var tryAgainButton = UIButton()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
     
    @objc func updateTTT() {
         print("Try to send request again")
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    private func setupViews() {
        backgroundColor = .white
        
        addSubview(errorImageView)
        addSubview(errorTitleLabel)
        addSubview(errorDescriptionLabel)
        addSubview(tryAgainButton)
        
        setContraints()
        
        configureErrorImageView()
        configureErrorTitleLabel()
        configureErrorDescriptionLabel()
        configureTryAgainButton()
    }
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 56),
            errorImageView.widthAnchor.constraint(equalToConstant: 56),
            
            errorTitleLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            errorTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            errorDescriptionLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 12),
            errorDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tryAgainButton.topAnchor.constraint(equalTo: errorDescriptionLabel.bottomAnchor, constant: 12),
            tryAgainButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 343),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
     
     private func configureErrorImageView() {
         errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.clipsToBounds = true
        errorImageView.contentMode = .scaleAspectFill
        errorImageView.image = UIImage(named: "flying-saucer")
    }
    
    private func configureErrorTitleLabel() {
        errorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        errorTitleLabel.text = "Какой-то сверхразум все сломал"
        errorTitleLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        errorTitleLabel.font = UIFont(name: "Inter-SemiBold", size: 17)
    }
    
    private func configureErrorDescriptionLabel() {
        errorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        errorDescriptionLabel.text = "Постараемся быстро починить"
        errorDescriptionLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        errorDescriptionLabel.font = UIFont(name: "Inter-Regular", size: 16)
    }
    
    private func configureTryAgainButton() {
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.setTitle("Попробовать снова", for: .normal)
        tryAgainButton.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 13)
        tryAgainButton.setTitleColor(UIColor.systemGray4, for: .highlighted)
        tryAgainButton.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
    }
    
}
