//
//  SortContactsController.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

protocol SortApplyDelegate: AnyObject{
    func applySort(_ sortingType: SortingType)
}

final class SortViewController: UIViewController {
    
    private let alphabeticallySortingView = RadioButtonView()
    private let byBirthdaySortingView = RadioButtonView()
    private let initialSortingType: SortingType
    
    weak var sortApplyDelegate: SortApplyDelegate?
    
    init(initialSortingType: SortingType) {
        self.initialSortingType = initialSortingType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
//        backButtonSetup()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Сортировка"
        
        setupSorting(.alphabetically)
        setupSorting(.byBirthday)
    }
    
    private func setConstraints() {
        alphabeticallySortingView.translatesAutoresizingMaskIntoConstraints = false
        byBirthdaySortingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alphabeticallySortingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            alphabeticallySortingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            alphabeticallySortingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            alphabeticallySortingView.heightAnchor.constraint(equalToConstant: 60),
            
            byBirthdaySortingView.topAnchor.constraint(equalTo: alphabeticallySortingView.bottomAnchor),
            byBirthdaySortingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            byBirthdaySortingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            byBirthdaySortingView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupSorting(_ sortingType: SortingType) {
        let sortingView: RadioButtonView
        let description: String
        switch sortingType {
        case .alphabetically:
            sortingView = alphabeticallySortingView
            description = "По алфавиту"
            sortingView.selectButton.isSelected = initialSortingType == sortingType
            sortingView.selectButton.addTarget(self, action: #selector(alphabeticallyButtonTapped), for: .touchUpInside)
            let tapGestureAlph = UITapGestureRecognizer(target: self,action: #selector(alphabeticallyButtonTapped))
            sortingView.descriptionLabel.addGestureRecognizer(tapGestureAlph)
            view.addSubview(sortingView)
            sortingView.descriptionLabel.text = description
        case .byBirthday:
            sortingView = byBirthdaySortingView
            description = "По дню рождения"
            sortingView.selectButton.isSelected = initialSortingType == sortingType
            sortingView.selectButton.addTarget(self, action: #selector(byBirthdayButtonTapped), for: .touchUpInside)
            let tapGestureBirth = UITapGestureRecognizer(target: self,action: #selector(byBirthdayButtonTapped))
            sortingView.descriptionLabel.addGestureRecognizer(tapGestureBirth)
            view.addSubview(sortingView)
            sortingView.descriptionLabel.text = description
        case .withoutSorting:
            print("Randomize")
        }
    }
    
    @objc func alphabeticallyButtonTapped(_ sender: UIButton) {
        print("alphabeticallyButtonTapped")
        if alphabeticallySortingView.selectButton.isSelected {
            sortApplyDelegate?.applySort(.withoutSorting)
        } else {
            sortApplyDelegate?.applySort(.alphabetically)
        }
        alphabeticallySortingView.selectButton.isSelected = !alphabeticallySortingView.selectButton.isSelected
        byBirthdaySortingView.selectButton.isSelected = false
        dismiss(animated: true)
    }
    
    @objc func byBirthdayButtonTapped(_ sender: UIButton) {
        print("byBirthdayButtonTapped")
        if byBirthdaySortingView.selectButton.isSelected {
            sortApplyDelegate?.applySort(.withoutSorting)
        } else {
            sortApplyDelegate?.applySort(.byBirthday)
        }
        alphabeticallySortingView.selectButton.isSelected = false
        byBirthdaySortingView.selectButton.isSelected = !byBirthdaySortingView.selectButton.isSelected
        dismiss(animated: true)
    }
    
//    private func backButtonSetup() {
//        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"),
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(backButtonTapped))
//        backButton.tintColor = UIColor.black
//        navigationItem.leftBarButtonItem = backButton
//    }
//    
//    @objc private func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
    
}
