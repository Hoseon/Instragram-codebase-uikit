//
//  SearchController.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/11.
//

import Foundation
import UIKit

class SearchController: UITableViewController {
    // MARK: - Properties
    private let reuseIdentifier = "UserCell"
    
    private var users = [User]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        configureTableView()
        fetchUsers()
        configureSearchController()
    }
    
    
    
    // MARK: - Helpers
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "-\(users[indexPath.row].username)")
        let controller = ProfileController(user: users[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({$0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText)})
        //테이블 뷰 다시 로드
        self.tableView.reloadData()
    }
}


