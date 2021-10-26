//
//  Group.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2020.
//

import UIKit
import RealmSwift

// MARK: - Model

class GroupResponse: Decodable {
    let response: Response
    
    class Response: Decodable {
        let items: [Group]
    }
}

class Group: Object, Decodable {
    @objc dynamic var name : String = ""
    @objc dynamic var logo : String = ""
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case logo = "photo_100"
    }
    
    override static func primaryKey() -> String? {
            return "name"
        }
}
