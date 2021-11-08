//
//  NewsCellProtocol.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2021.
//

import UIKit

typealias NewsCell = UITableViewCell & NewsCellProtocol

protocol NewsCellProtocol {
    func configure(item: NewsfeedItem)
}
