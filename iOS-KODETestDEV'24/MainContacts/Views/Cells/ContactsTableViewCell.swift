//
//  ContactsTableViewCell.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class ContactTableViewCell: UITableViewCell {
    
    private let networkManager = NetworkManager.shared
    
    private var photoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let positionLabel = UILabel()
    private let userTagLabel = UILabel()
    var dateOfBirthLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        nameLabel.text = nil
        positionLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        addSubview(photoImageView)
        addSubview(nameLabel)
        addSubview(positionLabel)
        addSubview(userTagLabel)
        addSubview(dateOfBirthLabel)
        
        setConstraints()
        
        configurePhotoImageView()
        configureNameLabel()
        configurePositionLabel()
        configureUserTagLabel()
        configureDateOfBirthLabel()
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        userTagLabel.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 72),
            photoImageView.widthAnchor.constraint(equalToConstant: 72),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            positionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            userTagLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            userTagLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            
            dateOfBirthLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            dateOfBirthLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configure(contacts: Contact) {
        nameLabel.text = contacts.firstName + " " + contacts.lastName
        positionLabel.text = contacts.position
        userTagLabel.text = contacts.userTag.lowercased()
        
        let formattedDate = DateFormat.formatDate(contacts.birthday,
                                                  fromFormat: "yyyy-MM-dd",
                                                  toFormat: "dd MMM",
                                                  localeIdentifier: "ru_RU")
        guard let formattedDate = formattedDate else {
            return
        }
        
        if formattedDate.prefix(1) == "0" {
            let newFormattedDate = formattedDate.dropFirst()
            dateOfBirthLabel.text = String(newFormattedDate.prefix(5))
        } else {
            dateOfBirthLabel.text = String(formattedDate.prefix(6))
        }
        
        networkManager.fetchAvatar(from: contacts.avatarUrl) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            } else {
                self.photoImageView.image = UIImage(named: "goose")
                print("Ошибка при загрузке данных")
            }
        }
        
    }
    
    private func configurePhotoImageView() {
        photoImageView.layer.cornerRadius = 36
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
    }
    
    private func configureNameLabel() {
        nameLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        nameLabel.font = UIFont(name: "Inter-Medium", size: 16)
    }
    
    private func configurePositionLabel() {
        positionLabel.textColor = UIColor(red: 0.333, green: 0.333, blue: 0.361, alpha: 1)
        positionLabel.font = UIFont(name: "Inter-Regular", size: 13)
    }
    
    private func configureUserTagLabel() {
        userTagLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        userTagLabel.font = UIFont(name: "Inter-Medium", size: 14)
    }
    
    private func configureDateOfBirthLabel() {
        dateOfBirthLabel.textColor = UIColor(red: 0.333, green: 0.333, blue: 0.361, alpha: 1)
        dateOfBirthLabel.font = UIFont(name: "Inter-Regular", size: 15)
    }
    
}
