//
//  ContactView.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class CardContactView: UIView {
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let positionLabel = UILabel()
    let userTagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(photoImageView)
        addSubview(nameLabel)
        addSubview(positionLabel)
        addSubview(userTagLabel)
        
        backgroundColor = UIColor(red: 247, green: 247, blue: 248, alpha: 1)
        
        configurePhotoImageView()
        configureNameLabel()
        configurePositionLabel()
        configureUserTagLabel()
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        userTagLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            photoImageView.heightAnchor.constraint(equalToConstant: 104),
            photoImageView.widthAnchor.constraint(equalToConstant: 104),
            
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 26),
            
            userTagLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            userTagLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            userTagLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            positionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            positionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            positionLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    private func configurePhotoImageView() {
        photoImageView.layer.cornerRadius = 50
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
    }
    
    private func configureNameLabel() {
        nameLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        nameLabel.font = UIFont(name: "Inter-Bold", size: 24)
    }
    
    private func configurePositionLabel() {
        positionLabel.textColor = UIColor(red: 0.333, green: 0.333, blue: 0.361, alpha: 1)
        positionLabel.font = UIFont(name: "Inter-Regular", size: 13)
    }
    
    private func configureUserTagLabel() {
        userTagLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        userTagLabel.font = UIFont(name: "Inter-Regular", size: 17)
    }
    
}
