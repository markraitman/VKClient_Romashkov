//
//  NewsViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 04.01.2021.
//

import UIKit

enum PostCellType: Int, CaseIterable {
    case author
    case content
    case likeCount
}

final class NewsViewController: UITableViewController {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.get { [weak self] (items) in
            self?.news = items
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Web Service
    
    lazy var service = VKNewsfeedService()
    
    // MARK: - Properties
    
    var news: [NewsfeedItem] = []
    
    
//    private var news = [
//        News(newsAuthorAvatar: UIImage(named: "Habr"),
//             newsAuthorName: "Habr",
//             newsDate: "08.01.2021",
//             newsText: "Электромеханический арифмометр ВК-2. Название расшифровывается как Вычислитель Клавишный, вторая модель. Слово «клавишный», вынесенное в название, призвано подчеркнуть одно из основных достоинств машины — ввод чисел и операций с помощью клавиш: http://amp.gs/MIyZ",
//             type: .post),
//        News(newsAuthorAvatar: UIImage(named: "ITHumor"),
//             newsAuthorName: "ITHumor",
//             newsDate: "07.01.2021",
//             newsPhoto: UIImage(named: "followers"),
//             type: .image),
//        News(newsAuthorAvatar: UIImage(named: "GeekBrains"),
//             newsAuthorName: "GeekBrains",
//             newsDate: "07.01.2021",
//             newsText: "Как попасть в геймдев? Именно этой теме был посвящен осенний митап, который мы провели совместно с TalentsInGames. На встрече обсудили поиск работы после курсов, собеседования, зарплату на стартовых позициях и многое другое. Всю информацию отразили для вас в статье: http://amp.gs/MIN3",
//             type: .post),
//        News(newsAuthorAvatar: UIImage(named: "IamProgrammist"),
//             newsAuthorName: "IamProgrammist",
//             newsDate: "06.01.2021",
//             newsPhoto: UIImage(named: "newCode"),
//             type: .image),
//        News(newsAuthorAvatar: UIImage(named: "ITHumor"),
//             newsAuthorName: "ITHumor",
//             newsDate: "05.01.2021",
//             newsPhoto: UIImage(named: "goodNight"),
//             type: .image)
//    ]
    
    // MARK: - Section
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostCellType.allCases.count
    }
    
    // MARK: - Cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = news[indexPath.section]
        let postCellType = PostCellType(rawValue: indexPath.row)
        var cellIdentifier = ""
        
        switch postCellType {
        
        case .author:
            cellIdentifier = "AuthorOfFeedTableViewCell"
            
        case .content:
            cellIdentifier = contentCellIdentifier(item)
            
        case .likeCount:
            cellIdentifier = "LikeCountTableViewCell"
            
        default:
            return UITableViewCell()
        }
        
        cellIdentifier = "LikeCountTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsCell
        cell.configure(item: item)
        return cell
    }
    
    private func contentCellIdentifier(_ item: NewsfeedItem) -> String{
        switch item.type {
        case .post:
            return "TextOfFeedTableViewCell"
        case .image:
            return "PhotoOfFeedTableViewCell"
        }
    }
}
