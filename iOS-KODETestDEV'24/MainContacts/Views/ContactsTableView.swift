//
//  ContactsTableView.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

final class ContactsTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .white
        self.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactTableViewCell")
        self.separatorStyle = .none
    }
    
}
