//
//  RadioButtonView.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class RadioButtonView: UIView {
    
    var selectButton = UIButton()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(selectButton)
        addSubview(descriptionLabel)
        backgroundColor = .white
        
        configureSelectButton()
        configureDescriptionLabel()
    
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            selectButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            selectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: selectButton.trailingAnchor, constant: 12),
            descriptionLabel.centerYAnchor.constraint(equalTo: selectButton.centerYAnchor)
        ])
    }
    
    private func configureSelectButton() {
        selectButton.setImage(UIImage(named: "unselected"), for: .normal)
        selectButton.setImage(UIImage(named: "selected"), for: .selected)
    }
    
    @objc func radioButtonSelected(sender: UIButton) {
        print("radioButtonSelected")
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        descriptionLabel.font = UIFont(name: "Inter-Medium", size: 16)
        descriptionLabel.isUserInteractionEnabled = true
    }
    
}
