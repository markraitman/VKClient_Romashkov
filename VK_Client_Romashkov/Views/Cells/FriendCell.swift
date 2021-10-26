//
//  FriendCell.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2020.
//

import UIKit

final class FriendCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
    @IBOutlet weak var friendImageView: AvatarControl!
    @IBOutlet weak var friendNameLabel: UILabel!

}
