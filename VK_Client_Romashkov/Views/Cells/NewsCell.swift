//
//  NewsCell.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 04.01.2021.
//

import UIKit

final class NewsCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: AvatarControl!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var newsPhoto: UIImageView!
}
