//
//  MyGroupsTableViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2020.
//

import UIKit
import Realm
import RealmSwift
import SwiftUI

final class MyGroupsTableViewController: UITableViewController {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableAndRealm()
        VKservice.getGroups()
    }
    
    // MARK: - Web Service
    
    let VKservice = VKAPIService()
    
    // MARK: - Realm
    
    let realm = try! Realm()
    var token: NotificationToken?
    
    func pairTableAndRealm() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: config) else { return }
        
        let groups = realm.objects(Group.self).filter("name != %@", "DELETED")
        
        
        token = groups.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial (let groups):
                self?.myGroups = Array(groups)
                self?.tableView.reloadData()
            case .update(let groups, _, _, _):
                self?.myGroups = Array(groups)
                self?.tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - DataSource
    
    var myGroups: [Group] = []
    
    // MARK: - Section
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myGroups.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupsCell", for: indexPath) as! GroupCell
        
        let groups = myGroups[indexPath.row]
        cell.groupNameLabel.text = groups.name
        cell.groupImageView.avatarImageView.downloadImage(urlPath: groups.logo)
        
        return cell
    }
    
    // MARK: - Segue
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            
            let allGroupsController = segue.source as! AllGroupsTableViewController
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                let group = allGroupsController.allGroups[indexPath.row]
                if !myGroups.contains(where: {$0.name == group.name}){
                    myGroups.append(allGroupsController.allGroups[indexPath.row])
                    tableView.insertRows(at: [IndexPath(row: myGroups.count - 1, section: 0)],with: .fade)
                    tableView.reloadData()
                } else if
                    !myGroups.contains(where: {$0.name == group.name}){
                    myGroups.append(allGroupsController.searchingGroups[indexPath.row])
                    tableView.insertRows(at: [IndexPath(row: myGroups.count - 1, section: 0)],with: .fade)
                    tableView.reloadData()
                }
            }
        }
    }
}

