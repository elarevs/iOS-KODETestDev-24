//
//  ContactsSearchBar.swift
//  iOS-KODETestDEV'24
//
//  Created by Artem Elchev on 22.03.2024.
//

import Foundation
import UIKit

protocol ContactsSearchBarDelegate: AnyObject {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func searchBarBookmarkButtonClicked(_ searcBar: UISearchBar)
}

final class ContactsSearchBar: UISearchBar {
    
    weak var searchBarDelegate: ContactsSearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSearchBar() {
        self.delegate = self
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchBarStyle = .minimal
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "Введи имя, тег, почту...",
                                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                                            UIColor(red: 0.76, green: 0.76, blue: 0.78, alpha: 1)])
        self.searchTextField.layer.cornerRadius = 16
        self.searchTextField.clipsToBounds = true
        self.searchTextField.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        self.searchTextField.backgroundColor = UIColor(cgColor: CGColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1))
        
        self.setImage(UIImage(named: "searchLight"), for: .search, state: .normal)
        self.setImage(UIImage(named: "optionUnselected"), for: .bookmark, state: .normal)
        self.setImage(UIImage(named: "optionSelected"), for: .bookmark, state: .selected)
        self.showsBookmarkButton = true
        self.setImage(UIImage(named: "clear"), for: .clear, state: .normal)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1),
            .font: UIFont(name: "Inter-SemiBold", size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
    }

}

extension ContactsSearchBar: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarDelegate?.searchBar(searchBar, textDidChange: searchText)
        self.setImage(UIImage(named: "searchDark"), for: .search, state: .normal)
        self.showsCancelButton = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.showsCancelButton = true
        self.setImage(UIImage(named: "searchDark"), for: .search, state: .normal)
        self.showsBookmarkButton = false
        self.placeholder = ""
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.tintColor = UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.showsCancelButton = false
        self.setImage(UIImage(named: "searchLight"), for: .search, state: .normal)
        self.showsBookmarkButton = true
        self.placeholder = "Введи имя, тег, почту ..."
    }
    
    func searchBarBookmarkButtonClicked(_ searcBar: UISearchBar) {
        searchBarDelegate?.searchBarBookmarkButtonClicked(searcBar)
    }
    
}
