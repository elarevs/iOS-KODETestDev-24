//
//  ViewController.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import UIKit
import Foundation

// MARK: - Core
final class ContactsViewController: UIViewController {
    
    // MARK: - Consts & variables
    var counterOfContactsAfter2025 = 0  // - переменная для посчёта количества контактов в секции
    var nameOfSections = ["2024", "2025"]
    
    private let networkManager = NetworkManager.shared // - синглтон
    private let contactsSearchBar = ContactsSearchBar()
    private let departmentMenuCollection = DepartmentMenuCollectionView()
    private let contactsTable = ContactsTableView()
    private let dataRefreshControl = UIRefreshControl()
    // Errors
    private var searchError = SearchError()
    private let fatalError = FatalError()
    
    private var contacts = [Contact]()
    private var sortedContacts = [Contact]()
    private var selectedDepartment: Departments = .all
    private var currentSortingType: SortingType = .withoutSorting
    private var searchText: String = ""
    private let cellIdentifier = "ContactTableViewCell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup view
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(contactsSearchBar)
        view.addSubview(departmentMenuCollection)
        view.addSubview(contactsTable)
        view.addSubview(fatalError)
        view.addSubview(searchError)
        
        errorReloadSetup()
        errorViewToggleVisibility(isHidden: false)
        pullToRefreshSetup()
        fetchContacts()
        
        departmentMenuCollection.sortDelegate = self
        contactsSearchBar.contactsSearchBarDelegate = self
        
        searchError.isHidden = true
        
        contactsTable.delegate = self
        contactsTable.dataSource = self
        
        contactsSearchBar.translatesAutoresizingMaskIntoConstraints = false
        departmentMenuCollection.translatesAutoresizingMaskIntoConstraints = false
        contactsTable.translatesAutoresizingMaskIntoConstraints = false
        dataRefreshControl.translatesAutoresizingMaskIntoConstraints = false
        searchError.translatesAutoresizingMaskIntoConstraints = false
        fatalError.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            fatalError.topAnchor.constraint(equalTo: view.topAnchor, constant: -100),
            fatalError.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fatalError.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            fatalError.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fatalError.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchError.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            searchError.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchError.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchError.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Error
    private func errorReloadSetup(){
        fatalError.tryAgainButton.addTarget(self, action: #selector(requestData), for: .touchUpInside)
        fatalError.isHidden = true
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
    
    // MARK: - Refresh
    private func pullToRefreshSetup() {
        dataRefreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        contactsTable.addSubview(dataRefreshControl)
    }
    
    @objc private func didPullToRefresh() {
        fetchContacts()
        dataRefreshControl.endRefreshing()
    }
    
    // MARK: - Networking
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
    
    // MARK: - Updates
    private func updateUIOnSuccess() {
        self.dataRefreshControl.endRefreshing()
        self.sortedContactsByDepartment()
        self.departmentMenuCollection.updateSortDelegate()
        
        self.fatalError.isHidden = true
        self.errorViewToggleVisibility(isHidden: false)
        
        if currentSortingType != .withoutSorting {
            contactsSearchBar.setImage(UIImage(named: "optionSelected"), for: .bookmark, state: .normal)
        } else {
            contactsSearchBar.setImage(UIImage(named: "optionUnselected"), for: .bookmark, state: .normal)
        }
    }
    
    private func updateUIOnFailure() {
        DispatchQueue.main.async {
            self.fatalError.isHidden = false
            self.errorViewToggleVisibility(isHidden: true)
        }
    }
    
}

// MARK: - TableView Delegate + DataSource

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentSortingType == .byBirthday {
            return 2
        }
        else {
            return 1
        }
    }
    
    // MARK: - Number of rows in sections
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
    
    // MARK: - Content of cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        let contact = sortedContacts[indexPath.row]
        print(sortedContacts.count)
        if currentSortingType == .byBirthday {
            cell.dateOfBirthLabel.isHidden = false
//          print(howManyContactsAfter2025)
            if indexPath.section == 0 {
                cell.configure(contacts: contact)
            } else if indexPath.section == 1 {
//                print(sortedContacts.count)
//                print([indexPath.row + sortedContacts.count - counterOfContactsAfter2025])
                cell.configure(contacts: sortedContacts[indexPath.row + sortedContacts.count - counterOfContactsAfter2025])
            }
        } else {
            cell.dateOfBirthLabel.isHidden = true
            cell.configure(contacts: contact)
        }
        return cell
    }
    
    // MARK: - Tapped for row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //снять выделение при нажатии
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
        navigationController?.pushViewController(cardContactsViewController, animated: true) //переход на карточку с контактом
    }
    
    // MARK: - Title section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nameOfSections[section]
    }
    
    // MARK: - Custom header view
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
    
    // MARK: - Height of header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (currentSortingType == .alphabetically) || (currentSortingType == .withoutSorting) {
            return 0
        } 
//        else if section >= sortedContacts.count {
//            return 0
//        }
            else {
                return 30
            }
    }
    
}

// MARK: - Sorted in departments delegate
extension ContactsViewController: SortedDepartmentsDelegate {
    func didSelectSort(selectedData: Departments) {
        selectedDepartment = selectedData
        sortedContactsByDepartment()
    }
}

// MARK: - Sorted apply delegate (alhabeticall/birthday/without)
extension ContactsViewController: SortApplyDelegate {
    func applySort(_ sortingType: SortingType) {
        currentSortingType = sortingType
        sortedContactsByDepartment()
    }
}

// MARK: - Contacts SearchBar Delegate
extension ContactsViewController: ContactsSearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        sortedContactsByDepartment()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let secondVC = SortViewController(initialSortingType: currentSortingType)
        secondVC.sortApplyDelegate = self
        navigationController?.present(secondVC, animated: true) //переход на карточку с контактом
//        let navVC = UINavigationController(rootViewController: secondVC)
//        if let sheet = navVC.sheetPresentationController {
//            sheet.detents = [.large()]
//        }
//        navigationController?.present(navVC, animated: true)
    }
}

// MARK: - Counting contacts births after 2025
extension ContactsViewController {
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
        
        for contact in sortedContacts {
            if someDateTime! < contact.currentBirth! {
                counterOfContactsAfter2025 = counterOfContactsAfter2025 + 1
            } else {
                counterOfContactsAfter2025 = counterOfContactsAfter2025 + 0
            }
        }
        return counterOfContactsAfter2025
    }
}

// MARK: - Sorted
extension ContactsViewController {
    func sortedContactsByDepartment() {
        if selectedDepartment == .all {
            sortedContacts = contacts
        } else {
            sortedContacts = contacts.filter { $0.department == selectedDepartment }
        }
        
        if !searchText.isEmpty {
            if selectedDepartment != .all {
                sortedContacts = sortedContacts.filter { contact in
                    return contact.firstName.lowercased().contains(searchText.lowercased()) ||
                    contact.lastName.lowercased().contains(searchText.lowercased()) ||
                    contact.userTag.lowercased().contains(searchText.lowercased()) ||
                    contact.phone.lowercased().contains(searchText.lowercased())
                }
            } else {
                sortedContacts = contacts.filter { contact in
                    return contact.firstName.lowercased().contains(searchText.lowercased()) ||
                    contact.lastName.lowercased().contains(searchText.lowercased()) ||
                    contact.userTag.lowercased().contains(searchText.lowercased()) ||
                    contact.phone.lowercased().contains(searchText.lowercased())
                }
            }
        }
        
        contactsTable.isHidden = sortedContacts.isEmpty
        searchError.isHidden = !sortedContacts.isEmpty
        
        contactsSearchBar.searchTextField.clearButtonMode = .always
        if !searchError.isHidden {
            contactsSearchBar.searchTextField.clearButtonMode = .never
        }
        
        switch currentSortingType {
        case .alphabetically:
            self.contactsSearchBar.setImage(UIImage(named: "optionSelected"), for: .bookmark, state: .normal)
            sortedContacts.sort { $0.firstName < $1.firstName }
        case .byBirthday:
            self.contactsSearchBar.setImage(UIImage(named: "optionSelected"), for: .bookmark, state: .normal)
            sortedContacts = sortedContacts.sorted {
                if let date1 = $0.currentBirth, let date2 = $1.currentBirth {
                    return date1 < date2
                }
                return false
            }
            howManyContactsAfter2025()
        case .withoutSorting:
            contactsSearchBar.setImage(UIImage(named: "optionUnselected"), for: .bookmark, state: .normal)
            sortedContacts.shuffle()
        }
        contactsTable.reloadData()
    }
}
