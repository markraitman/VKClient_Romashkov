//
//  AllGroupsTableViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2020.
//

import UIKit

final class AllGroupsTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    // MARK: - Web Service
    
    let VKservice = VKAPIService()
    
    // MARK: - Properties
    
    var allGroups: [Group] = []
    var searchingGroups: [Group] = []
    private var searching = false
    
    // MARK: - Section
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingGroups.count
        } else {
            return allGroups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allGroupsCell", for: indexPath) as! GroupCell
        
        if searching {
            let filteredGroup = searchingGroups[indexPath.row]
            cell.groupNameLabel.text = filteredGroup.name
            cell.groupImageView.avatarImageView.downloadImage(urlPath: filteredGroup.logo)
        } else {
            let group = allGroups[indexPath.row]
            cell.groupNameLabel.text = group.name
            cell.groupImageView.avatarImageView.downloadImage(urlPath: group.logo)
        }
        return cell
    }
    
    // MARK: - Search Actions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            allGroups = [Group]().filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
            tableView.reloadData()
        } else {
            DispatchQueue.global().async {
                self.VKservice.groupSearch(searchText: searchText) { [weak self] searchedGroups in
                    self?.allGroups = searchedGroups
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
}
