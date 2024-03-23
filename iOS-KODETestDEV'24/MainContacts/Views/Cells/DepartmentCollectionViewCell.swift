//
//  DepartmentCollectionViewCell.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class DepartmentCollectionViewCell: UICollectionViewCell {
    
    let departmentLabel = UILabel()
    let selectedCellLine = UIView()
    let lineBottom = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(departmentLabel)
        addSubview(selectedCellLine)
        addSubview(lineBottom)
        
        configureDepartmentLabel()
        configureSelectedCell()
        configurelineBottom()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            departmentLabel.topAnchor.constraint(equalTo: self.topAnchor),
            departmentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            departmentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            selectedCellLine.topAnchor.constraint(equalTo: departmentLabel.bottomAnchor),
            selectedCellLine.leadingAnchor.constraint(equalTo: departmentLabel.leadingAnchor, constant: -12),
            selectedCellLine.trailingAnchor.constraint(equalTo: departmentLabel.trailingAnchor, constant: 12),
            selectedCellLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            selectedCellLine.heightAnchor.constraint(equalToConstant: 2),
   
            lineBottom.bottomAnchor.constraint(equalTo: selectedCellLine.bottomAnchor, constant: 1),
            lineBottom.heightAnchor.constraint(equalToConstant: 0.5),
            lineBottom.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineBottom.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureDepartmentLabel() {
        departmentLabel.translatesAutoresizingMaskIntoConstraints = false
        departmentLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        departmentLabel.font = UIFont(name: "Inter-SemiBold", size: 15)
    }
    
    private func configureSelectedCell() {
        selectedCellLine.translatesAutoresizingMaskIntoConstraints = false
        selectedCellLine.backgroundColor = UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1)
        selectedCellLine.isHidden = true
    }
    
    private func configurelineBottom() {
        lineBottom.translatesAutoresizingMaskIntoConstraints = false
        lineBottom.backgroundColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
    }
    
    func set(department: Departments) {
        departmentLabel.text = department.title
    }
    
}
