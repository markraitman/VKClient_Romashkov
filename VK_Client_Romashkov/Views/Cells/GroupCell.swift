//
//  GroupCell.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2020.
//

import UIKit

final class GroupCell: UITableViewCell {
    
    @IBOutlet weak var groupImageView: AvatarControl!
    @IBOutlet weak var groupNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

}
