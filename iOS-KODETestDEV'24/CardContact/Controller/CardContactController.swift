//
//  CardContactController.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class CardContactViewController: UIViewController {

    private let networkManager = NetworkManager.shared
    
    private let profileView = CardContactView()
    private let birthView = DateOfBirthView()
    private let phoneNumberView = PhoneView()
    var contactDetail: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        backButtonSetup()
        handlePhoneTapNumber()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(profileView)
        view.addSubview(birthView)
        view.addSubview(phoneNumberView)
        
        setupUserProfile()
    }
    
    private func setConstraints() {
        profileView.translatesAutoresizingMaskIntoConstraints = false
        birthView.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 184),
            
            birthView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 32),
            birthView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            birthView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            birthView.heightAnchor.constraint(equalToConstant: 60),
            
            phoneNumberView.topAnchor.constraint(equalTo: birthView.bottomAnchor, constant: 6),
            phoneNumberView.leadingAnchor.constraint(equalTo: birthView.leadingAnchor),
            phoneNumberView.trailingAnchor.constraint(equalTo: birthView.trailingAnchor),
            phoneNumberView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupUserProfile() {
        guard let contactDetail = contactDetail else {
            return
        }
        loadImage(contactDetail)
        assignData(contactDetail)
        formatAndDisplayDateOfBirth(contactDetail)
        displayAge(contactDetail)
    }
    
    private func loadImage(_ contactDetail: Contact) {
        networkManager.fetchAvatar(from: contactDetail.avatarUrl) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.profileView.photoImageView.image = image
                }
            } else {
                print("Ошибка при загрузке данных")
            }
        }
    }
    
    private func assignData(_ contactDetail: Contact) {
        profileView.nameLabel.text = contactDetail.firstName + " " + contactDetail.lastName
        profileView.userTagLabel.text = contactDetail.userTag.lowercased()
        profileView.positionLabel.text = contactDetail.position
        let phoneString = String(contactDetail.phone).replacingOccurrences(of: "-", with: " ")
        let countryCode = 7
        let operatorCode = phoneString.prefix(3)
        let lastDigits = phoneString.suffix(8).dropLast(2) + " " + phoneString.dropFirst(10)
        phoneNumberView.numberLabel.text = "+\(countryCode) " + "(\(operatorCode))" + " " + "\(lastDigits)"
    }
    
    private func formatAndDisplayDateOfBirth(_ contactDetail: Contact) {
        let formattedDate = DateFormat.formatDate(contactDetail.birthday, fromFormat: "yyyy-MM-dd", toFormat: "d MMMM yyyy", localeIdentifier: "ru_RU")
        birthView.dateOfBirthLabel.text = formattedDate
    }
    
    private func displayAge(_ contactDetail: Contact) {
        let age = DateFormat.calculateAgeFromDate(contactDetail.birthday, format: "yyyy-MM-dd")
        var stringOfYears = "года"
        if (age % 10 == 0) || (age < 21) || ( (age > 20) && (age % 10 > 4) && (age % 10 != 1) ) {
            stringOfYears = "лет"
        } else if (age == 1) || ( (age > 20) && (age % 10 == 1) ) {
            stringOfYears = "год"
        }
        birthView.ageLabel.text = String(age) + " " + stringOfYears
    }
    
    private func backButtonSetup() {
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func handlePhoneTapNumber() {
        phoneNumberView.tapPhoneHandler = {
            self.handlePhoneTap()
        }
    }
    
    private func handlePhoneTap() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let phoneNumberTitle = phoneNumberView.numberLabel.text ?? "There's no number"
        let callAction = UIAlertAction(title: "\(phoneNumberTitle)", style: .default) { (_) in
            self.makeCall()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        callAction.setValue(UIColor(red: 0.198, green: 0.198, blue: 0.198, alpha: 1), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(red: 0.198, green: 0.198, blue: 0.198, alpha: 1), forKey: "titleTextColor")
        alertController.addAction(callAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func validatePhoneNumber() -> String? {
        guard let phoneNumber = phoneNumberView.numberLabel.text else {
            return nil
        }
        return phoneNumber
    }
    
    private func openCallURL(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)") else {
            print("URL не может быть создан")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                if success {
                    print("")
                } else {
                    print("Не удалось совершить звонок")
                }
            })
        } else {
            print("Устройство не может осуществить звонок")
        }
    }
    
    private func makeCall() {
        guard let phoneNumber = validatePhoneNumber() else {
            print("Некорректный номер телефона")
            return
        }
        openCallURL(phoneNumber: phoneNumber)
    }
    
}
