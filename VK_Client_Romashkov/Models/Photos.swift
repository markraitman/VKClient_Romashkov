//
//  Photos.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 12.03.2021.
//

import UIKit
import RealmSwift

// MARK: - Model

class PhotoResponse: Decodable {
    let response: Response
    
    class Response: Decodable {
        let items: [Photo]
    }
}

class Photo: Object, Decodable {
    @objc dynamic var id : Int = 0
    @objc dynamic var ownerId : Int = 0
    @objc dynamic var imageURL : String = ""
 
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sizes
        case src
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)
        
        var sizesArrayValues = try values.nestedUnkeyedContainer(forKey: .sizes)
        let firstValue = try sizesArrayValues.nestedContainer(keyedBy: CodingKeys.self)
        self.imageURL = try firstValue.decode(String.self, forKey: .src)
    }
}

class PhotoSize: Decodable {
    @objc dynamic var src: String = ""
}
