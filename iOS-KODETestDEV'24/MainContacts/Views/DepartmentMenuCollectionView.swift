//
//  DepartmentCollectionView.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

protocol SortedDepartmentsDelegate: AnyObject {
    func didSelectSort(selectedData: Departments)
}

final class DepartmentMenuCollectionView: UICollectionView {
    
    private var departments: [Departments] = []
    private let departmentLayout = UICollectionViewFlowLayout()
    private var selectedIndexPath: IndexPath?
    
    weak var sortDelegate: SortedDepartmentsDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: departmentLayout)
        configureCollectionView()
        setCollectionViewDelegates()
        departments = receiveData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        departmentLayout.scrollDirection = .horizontal
        departmentLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.backgroundColor = .white
        self.register(DepartmentCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: type(of: DepartmentCollectionViewCell.self)))
        self.showsHorizontalScrollIndicator = false
        selectedIndexPath = IndexPath(item: 0, section: 0)
    }
    
    func setCollectionViewDelegates() {
        self.delegate = self
        self.dataSource = self
    }
    
}

extension DepartmentMenuCollectionView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return departments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: type(of: DepartmentCollectionViewCell.self)), for: indexPath) as? DepartmentCollectionViewCell else {
            return DepartmentCollectionViewCell()
        }
        
        let department = departments[indexPath.row]
        cell.set(department: department)
        
        if selectedIndexPath == indexPath {
            cell.departmentLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
            cell.selectedCellLine.isHidden = false
        } else {
            cell.departmentLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
            cell.selectedCellLine.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousSelectedIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? DepartmentCollectionViewCell
        {
            previousCell.departmentLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
            previousCell.selectedCellLine.isHidden = true
        }
        selectedIndexPath = indexPath
        collectionView.reloadItems(at: [indexPath])
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateSortDelegate()
    }
    
    func updateSortDelegate() {
        if let selectedIndexPath = selectedIndexPath {
            let selectedSort = departments[selectedIndexPath.item]
            sortDelegate?.didSelectSort(selectedData: selectedSort)
        } else {
            print("Delegate not called")
        }
    }
}

extension DepartmentMenuCollectionView {
    private func receiveData() -> [Departments] {
        return Departments.allCases
    }
}
