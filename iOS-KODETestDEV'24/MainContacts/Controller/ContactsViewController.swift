//
//  ViewController.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import UIKit
import Foundation

final class ContactsViewController: UIViewController {
    
    var counterOfContactsAfter2025 = 0
    var nameOfSections = ["2024", "2025"]
    private let networkManager = NetworkManager.shared
    
    private let contactsSearchBar = ContactsSearchBar()
    private let departmentMenuCollection = DepartmentMenuCollectionView()
    private let contactsTable = ContactsTableView()
    private let dataRefreshControl = UIRefreshControl()
    private var searchError = SearchError()
    private let errorReload = FatalError()
    
    private var contacts = [Contact]()
    private var filteredContacts = [Contact]()
    private var selectedDepartment: Departments = .all
    private var currentSortingType: SortingType = .withoutSorting
    private var searchText: String = ""
    private let cellIdentifier = "ContactTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(contactsSearchBar)
        view.addSubview(departmentMenuCollection)
        view.addSubview(contactsTable)
        view.addSubview(errorReload)
        view.addSubview(searchError)
        
        errorReloadSetup()
        errorViewToggleVisibility(isHidden: false)
        pullToRefreshSetup()
        fetchContacts()
        
        departmentMenuCollection.sortDelegate = self
        contactsSearchBar.searchBarDelegate = self
        
        searchError.isHidden = true
        
        contactsTable.delegate = self
        contactsTable.dataSource = self
        
        contactsSearchBar.translatesAutoresizingMaskIntoConstraints = false
        departmentMenuCollection.translatesAutoresizingMaskIntoConstraints = false
        contactsTable.translatesAutoresizingMaskIntoConstraints = false
        dataRefreshControl.translatesAutoresizingMaskIntoConstraints = false
        searchError.translatesAutoresizingMaskIntoConstraints = false
        errorReload.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contactsSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            contactsSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contactsSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contactsSearchBar.heightAnchor.constraint(equalToConstant: 40),
            
            departmentMenuCollection.topAnchor.constraint(equalTo: contactsSearchBar.bottomAnchor, constant: 14),
            departmentMenuCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            departmentMenuCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            departmentMenuCollection.heightAnchor.constraint(equalToConstant: 36),
            
            contactsTable.topAnchor.constraint(equalTo: departmentMenuCollection.bottomAnchor),
            contactsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contactsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contactsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorReload.topAnchor.constraint(equalTo: view.topAnchor, constant: -100),
            errorReload.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorReload.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorReload.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorReload.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchError.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            searchError.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchError.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchError.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func errorReloadSetup(){
        errorReload.tryAgainButton.addTarget(self, action: #selector(requestData), for: .touchUpInside)
        errorReload.isHidden = true
    }
    
    @objc func requestData() {
        print("Try to send request again")
        fetchContacts()
    }
    
    private func errorViewToggleVisibility(isHidden: Bool) {
        contactsSearchBar.isHidden = isHidden
        departmentMenuCollection.isHidden = isHidden
        contactsTable.isHidden = isHidden
    }
    
    private func pullToRefreshSetup() {
        dataRefreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        contactsTable.addSubview(dataRefreshControl)
    }
    
    @objc private func didPullToRefresh() {
        fetchContacts()
        dataRefreshControl.endRefreshing()
    }
    
    private func fetchContacts() {
        networkManager.fetchContacts { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts
                self?.updateUIOnSuccess()
            case .failure(let error):
                print("Error in fetchContacts: \(error.rawValue)")
                self?.updateUIOnFailure()
            }
        }
    }
    
    private func updateContactData(_ contacts: [Contact]) {
        self.contacts = contacts
    }
    
    private func updateUIOnSuccess() {
        self.dataRefreshControl.endRefreshing()
        self.sortAndFilterContactsByDepartment()
        self.departmentMenuCollection.updateSortDelegate()
        self.errorReload.isHidden = true
        self.errorViewToggleVisibility(isHidden: false)
        if currentSortingType != .withoutSorting {
            contactsSearchBar.setImage(UIImage(named: "optionSelected"), for: .bookmark, state: .normal)
        } else {
            contactsSearchBar.setImage(UIImage(named: "optionUnselected"), for: .bookmark, state: .normal)
        }
    }
    
    private func updateUIOnFailure() {
        self.errorReload.isHidden = false
        self.errorViewToggleVisibility(isHidden: true)
    }
    
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource, SortButtonDelegate, ContactsSearchBarDelegate, SortApplyDelegate {
    
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
                return filteredContacts.count - counterOfContactsAfter2025
            } else if section == 1 {
                return counterOfContactsAfter2025
            }
        }
        return filteredContacts.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
  
        let contact = filteredContacts[indexPath.row]
        print(filteredContacts.count)
        if currentSortingType == .byBirthday {
            print(howManyContactsAfter2025)
            if indexPath.section == 0 {
                cell.configure(contacts: contact)
            } else if indexPath.section == 1 {
                print(filteredContacts.count)
                print([indexPath.row + filteredContacts.count - counterOfContactsAfter2025])
                cell.configure(contacts: filteredContacts[indexPath.row + filteredContacts.count - counterOfContactsAfter2025])
            }
        } else {
            cell.configure(contacts: contact)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.section, indexPath.row)
        var selectedContact = filteredContacts[indexPath.row]
        if currentSortingType == .byBirthday {
            if indexPath.section == 0 {
                selectedContact = filteredContacts[indexPath.row]
            } else if indexPath.section == 1 {
                selectedContact = filteredContacts[indexPath.row + filteredContacts.count - counterOfContactsAfter2025]
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
        } else if section >= filteredContacts.count {
            return 0
        }
        return 30
    }
    
    // MARK: - Extensions for UICollectionView
    func didSelectFilter(selectedData: Departments) {
        selectedDepartment = selectedData
        sortAndFilterContactsByDepartment()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        sortAndFilterContactsByDepartment()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let secondVC = SortViewController(initialSortingType: currentSortingType)
        secondVC.sortApplyDelegate = self
        let navVC = UINavigationController(rootViewController: secondVC)
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.large()]
        }
        navigationController?.present(navVC, animated: true)
    }
    
    func applyFilter(_ sortingType: SortingType) {
        currentSortingType = sortingType
        sortAndFilterContactsByDepartment()
    }
    
    func nextBirthday(for birthdayString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let birthday = dateFormatter.date(from: birthdayString)!
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month], from: birthday)
        
        return calendar.nextDate(after: .now, matching: components, matchingPolicy: .nextTime) ?? .distantFuture
    }
    
    func howManyContactsAfter2025() -> Int {
        counterOfContactsAfter2025 = 0
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 01
        dateComponents.day = 01
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let userCalendar = Calendar(identifier: .gregorian)
        let someDateTime = userCalendar.date(from: dateComponents)
        
        for contact in filteredContacts {
            if someDateTime! < contact.currentBirth! {
                counterOfContactsAfter2025 = counterOfContactsAfter2025 + 1
            } else {
                counterOfContactsAfter2025 = counterOfContactsAfter2025 + 0
            }
        }
        return counterOfContactsAfter2025
    }

    
    func sortAndFilterContactsByDepartment() {
        if selectedDepartment == .all {
            filteredContacts = contacts
        } else {
            filteredContacts = contacts.filter { $0.department == selectedDepartment }
        }
        
        if !searchText.isEmpty {
            if selectedDepartment != .all {
                filteredContacts = filteredContacts.filter { contact in
                    return contact.firstName.lowercased().contains(searchText.lowercased()) ||
                    contact.lastName.lowercased().contains(searchText.lowercased()) ||
                    contact.userTag.lowercased().contains(searchText.lowercased()) ||
                    contact.phone.lowercased().contains(searchText.lowercased())
                }
            } else {
                filteredContacts = contacts.filter { contact in
                    return contact.firstName.lowercased().contains(searchText.lowercased()) ||
                    contact.lastName.lowercased().contains(searchText.lowercased()) ||
                    contact.userTag.lowercased().contains(searchText.lowercased()) ||
                    contact.phone.lowercased().contains(searchText.lowercased())
                }
            }
        }
        
        contactsTable.isHidden = filteredContacts.isEmpty
        searchError.isHidden = !filteredContacts.isEmpty
        contactsSearchBar.searchTextField.clearButtonMode = .always
        
        if !searchError.isHidden {
            contactsSearchBar.searchTextField.clearButtonMode = .never
        }
        
        switch currentSortingType {
        case .alphabetically:
            self.contactsSearchBar.setImage(UIImage(named: "optionSelected"), for: .bookmark, state: .normal)
            filteredContacts.sort { $0.firstName < $1.firstName }
        case .byBirthday:
            self.contactsSearchBar.setImage(UIImage(named: "optionSelected"), for: .bookmark, state: .normal)
            filteredContacts = filteredContacts.sorted {
                if let date1 = $0.currentBirth, let date2 = $1.currentBirth {
                    return date1 < date2
                }
                return false
            }
            howManyContactsAfter2025()
        case .withoutSorting:
            contactsSearchBar.setImage(UIImage(named: "optionUnselected"), for: .bookmark, state: .normal)
            filteredContacts.shuffle()
        }
        contactsTable.reloadData()
    }
    
}
