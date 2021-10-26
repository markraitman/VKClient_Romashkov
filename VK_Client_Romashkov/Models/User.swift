//
//  User.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2020.
//

import UIKit
import RealmSwift

// MARK: - Model

class UserResponse:Decodable {
    let response: Response
    
    class Response: Decodable {
        let items: [User]
    }
}

class User:  Object, Decodable {
    @objc dynamic var id : Int = 0
    @objc dynamic var firstName : String = ""
    @objc dynamic var lastName : String = ""
    @objc dynamic var avatar : String = ""
    
    @objc dynamic var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_100"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
