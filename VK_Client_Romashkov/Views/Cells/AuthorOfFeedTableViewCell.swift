//
//  AuthorOfFeedTableViewCell.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 31.10.2021.
//

import UIKit
import Kingfisher

class AuthorOfFeedTableViewCell: UITableViewCell, NewsCellProtocol {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(item: NewsfeedItem) {
        if let authorImageUrl = item.authorImageUrl,
           let url = URL(string: authorImageUrl){
            authorImageView.kf.setImage(with: url)
        }
        authorImageView.image = UIImage()
        
        authorLabel.text = item.author
        
//        dateLabel.text = item.date
        dateLabel.text = "item.date"
    }

}
