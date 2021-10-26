//
//  NewsViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 04.01.2021.
//

import UIKit

final class NewsViewController: UITableViewController {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Properties
    
    private var news = [
        News(authorAvatar: UIImage(named: "Habr"),
             author: "Habr",
             date: "08.01.2021",
             text: "Электромеханический арифмометр ВК-2. Название расшифровывается как Вычислитель Клавишный, вторая модель. Слово «клавишный», вынесенное в название, призвано подчеркнуть одно из основных достоинств машины — ввод чисел и операций с помощью клавиш: http://amp.gs/MIyZ",
             photo: UIImage(named: "BK-2")),
        News(authorAvatar: UIImage(named: "ITHumor"),
             author: "ITHumor",
             date: "07.01.2021",
             text: "Два — это много?",
             photo: UIImage(named: "followers")),
        News(authorAvatar: UIImage(named: "GeekBrains"),
             author: "GeekBrains",
             date: "07.01.2021",
             text: "Как попасть в геймдев? Именно этой теме был посвящен осенний митап, который мы провели совместно с TalentsInGames. На встрече обсудили поиск работы после курсов, собеседования, зарплату на стартовых позициях и многое другое. Всю информацию отразили для вас в статье: http://amp.gs/MIN3",
             photo: UIImage(named: "gameDev")),
        News(authorAvatar: UIImage(named: "IamProgrammist"),
             author: "IamProgrammist",
             date: "06.01.2021",
             text: "С Новым кодом!",
             photo: UIImage(named: "newCode")),
        News(authorAvatar: UIImage(named: "ITHumor"),
             author: "ITHumor",
             date: "05.01.2021",
             text: "Спокойной ночи!",
             photo: UIImage(named: "goodNight")),
    ]
    
    // MARK: - Section
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    // MARK: - Cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        
        let allNews = news[indexPath.row]
        cell.authorImageView.image = allNews.authorAvatar
        cell.authorLabel.text = allNews.author
        cell.dateLabel.text = allNews.date
        cell.newsTextLabel.text = allNews.text
        cell.newsPhoto.image = allNews.photo
        
        return cell
    }
}
