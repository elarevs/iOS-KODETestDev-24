//
//  ContactsViewController+TableViewDelegate.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 23.03.2024.
//

import Foundation
import UIKit

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentSortingType == .byBirthday {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSortingType == .byBirthday {
            if section == 0 {
                return sortedContacts.count - counterOfContactsAfter2025
            } else if section == 1 {
                return counterOfContactsAfter2025
            }
        }
        return sortedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        let contact = sortedContacts[indexPath.row]
        print(sortedContacts.count)
        if currentSortingType == .byBirthday {
            print(howManyContactsAfter2025)
            if indexPath.section == 0 {
                cell.configure(contacts: contact)
            } else if indexPath.section == 1 {
                print(sortedContacts.count)
                print([indexPath.row + sortedContacts.count - counterOfContactsAfter2025])
                cell.configure(contacts: sortedContacts[indexPath.row + sortedContacts.count - counterOfContactsAfter2025])
            }
        } else {
            cell.configure(contacts: contact)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.section, indexPath.row)
        var selectedContact = sortedContacts[indexPath.row]
        if currentSortingType == .byBirthday {
            if indexPath.section == 0 {
                selectedContact = sortedContacts[indexPath.row]
            } else if indexPath.section == 1 {
                selectedContact = sortedContacts[indexPath.row + sortedContacts.count - counterOfContactsAfter2025]
            }
        }
        let cardContactsViewController = CardContactViewController()
        cardContactsViewController.contactDetail = selectedContact
        navigationController?.pushViewController(cardContactsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nameOfSections[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderSectionView(frame: CGRect.zero)
        headerView.yearLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        switch currentSortingType {
        case.alphabetically:
            headerView.isHidden = true
        case.byBirthday:
            headerView.isHidden = false
        case .withoutSorting:
            headerView.isHidden = true
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (currentSortingType == .alphabetically) || (currentSortingType == .withoutSorting) {
            return 0
        } else if section >= sortedContacts.count {
            return 0
        }
        return 30
    }
    
}
