//
//  PhotoOfFeedTableViewCell.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 31.10.2021.
//

import UIKit

class PhotoOfFeedTableViewCell: UITableViewCell, NewsCellProtocol {

    @IBOutlet weak var newsPhoto: UIImageView!
    
    func configure(item: NewsfeedItem) {
//        newsPhoto.image = item.newsPhoto
        newsPhoto.image = UIImage()
    }

}
