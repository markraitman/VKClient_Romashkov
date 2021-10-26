//
//  MyFriendsTableViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2020.
//

import UIKit
import Realm
import RealmSwift

final class MyFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LetterPickerDelegate, UISearchBarDelegate {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableAndRealm()
        VKservice.getFriends()
    }
    
    // MARK: - Web Service
    
    let VKservice = VKAPIService()
    
    // MARK: - Realm
    
    let realm = try! Realm()
    var token: NotificationToken?
    
    func pairTableAndRealm() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: config) else { return }
        
        allFriends = realm.objects(User.self).filter("firstName != %@", "DELETED")
        
        token = allFriends.observe { [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//            case .initial, .update:
//                self?.filteringFriends(text: self?.searchBar.text)  //не разобрался: добавления и удаления не работают
//                self?.tableView.reloadData()
//                self?.reloadDataSource()
//                self?.setupViews()
//            case .error(let error):
//                fatalError("\(error)")
//            }
            switch changes {
            case .initial(let allFriends):
                self?.filteredFriends = Array(allFriends)
                self?.tableView.reloadData()
                self?.reloadDataSource()
                self?.setupViews()
            case .update(let allFriends, _, _, _):
                self?.filteredFriends = Array(allFriends) //не разобрался: добавления и удаления не работают
                self?.tableView.reloadData()
                self?.reloadDataSource()
                self?.setupViews()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Data source
    
    private var sections: [String] = []
    private var allFriends: Results<User>!
    private var filteredFriends: [User] = []
    private var cashedSectionFriends: [String: [User]] = [:]
    
    func getFriends(for section: Int) -> [User] {
        let sectionLetter = sections[section]
        
        if let sectionFriends = cashedSectionFriends[sectionLetter] {
            return sectionFriends
        }
        
        let sectionFriends = filteredFriends.filter {
            $0.lastName.uppercased().prefix(1) == sectionLetter
        }
        cashedSectionFriends[sectionLetter] = sectionFriends
        return sectionFriends
    }
    
    func getFriend(for indexPath: IndexPath) -> User {
        return getFriends(for: indexPath.section)[indexPath.row]
    }
    
    func filteringFriends(text: String?) {
        if let text = text, !text.isEmpty {
            filteredFriends = allFriends.filter {
                $0.fullName.lowercased().contains(text.lowercased())
            }
        } else {
            filteredFriends = Array(allFriends)
        }
        
    }
    
    // MARK: - Setup
    
    private func reloadDataSource() {
        filteringFriends(text: searchBar.text)
        
        let allLetters = filteredFriends.map { String($0.lastName.uppercased().prefix(1))}
        sections = Array(Set(allLetters)).sorted()
        
        cashedSectionFriends = [:]
    }
    
    private func setupViews() {
        letterPicker.delegate = self
        letterPicker.letters = sections
    }
    
    // MARK: - Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getFriends(for: section).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // MARK: - Cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        
        let user = getFriend(for: indexPath)
        cell.friendNameLabel.text = user.fullName
        cell.friendImageView.avatarImageView.downloadImage(urlPath: user.avatar)
        
        return cell
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let view = segue.destination as? PhotosCollectionViewController,
            let indexPath = tableView.indexPathForSelectedRow
        {
            let photosOfFriend = getFriend(for: indexPath)
            view.title = photosOfFriend.fullName
            view.friendId = photosOfFriend.id
        }
    }
    
    // MARK: - LetterPickerDelegate
    
    func letterPicked(_ letter: String) {
        guard let sectionIndex = sections.firstIndex(where: { $0 == letter })
        else { return }
        
        let indexPath = IndexPath(row: 0, section: sectionIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadDataSource()
        tableView.reloadData()
        letterPicker.letters = sections
    }
    
    // MARK: - Animations
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.transform = scale
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        cell.transform = .identity
                        cell.alpha = 1
                       },
                       completion: nil)
    }
}
