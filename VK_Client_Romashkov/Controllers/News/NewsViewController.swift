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
    }
    
    // MARK: - Properties
    
    private var news = [
        News(newsAuthorAvatar: UIImage(named: "Habr"),
             newsAuthorName: "Habr",
             newsDate: "08.01.2021",
             newsText: "Электромеханический арифмометр ВК-2. Название расшифровывается как Вычислитель Клавишный, вторая модель. Слово «клавишный», вынесенное в название, призвано подчеркнуть одно из основных достоинств машины — ввод чисел и операций с помощью клавиш: http://amp.gs/MIyZ",
             type: .post),
        News(newsAuthorAvatar: UIImage(named: "ITHumor"),
             newsAuthorName: "ITHumor",
             newsDate: "07.01.2021",
             newsPhoto: UIImage(named: "followers"),
             type: .image),
        News(newsAuthorAvatar: UIImage(named: "GeekBrains"),
             newsAuthorName: "GeekBrains",
             newsDate: "07.01.2021",
             newsText: "Как попасть в геймдев? Именно этой теме был посвящен осенний митап, который мы провели совместно с TalentsInGames. На встрече обсудили поиск работы после курсов, собеседования, зарплату на стартовых позициях и многое другое. Всю информацию отразили для вас в статье: http://amp.gs/MIN3",
             type: .post),
        News(newsAuthorAvatar: UIImage(named: "IamProgrammist"),
             newsAuthorName: "IamProgrammist",
             newsDate: "06.01.2021",
             newsPhoto: UIImage(named: "newCode"),
             type: .image),
        News(newsAuthorAvatar: UIImage(named: "ITHumor"),
             newsAuthorName: "ITHumor",
             newsDate: "05.01.2021",
             newsPhoto: UIImage(named: "goodNight"),
             type: .image),
    ]
    
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
        
        switch postCellType {
        case .author:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorOfFeedTableViewCell", for: indexPath) as! AuthorOfFeedTableViewCell
            cell.authorImageView.image = item.newsAuthorAvatar
            cell.authorLabel.text = item.newsAuthorName
            cell.dateLabel.text = item.newsDate
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
            
        case .content:
            switch item.type {
            case .post:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextOfFeedTableViewCell", for: indexPath) as! TextOfFeedTableViewCell
                cell.newsTextView.text = item.newsText
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                return cell
            case .image:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoOfFeedTableViewCell", for: indexPath) as! PhotoOfFeedTableViewCell
                cell.newsPhoto.image = item.newsPhoto
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                return cell
            }
 
        case .likeCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikeCountTableViewCell", for: indexPath) as! LikeCountTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
}
