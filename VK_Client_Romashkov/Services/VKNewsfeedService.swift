//
//  VKNewsfeedService.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 07.11.2021.
//

import Foundation
import SwiftyJSON

struct NewsfeedItem {
    var sourceId: Int
    var text: String
    var date: Double
    var author: String?
    var authorImageUrl: String?
    var type: NewsItemType = .post
    
    
    init(json: JSON) {
        self.sourceId = json["source_id"].intValue
        self.text = json["text"].stringValue
        self.date = json["date"].doubleValue
    }
}

struct NewsfeedProfile {
    var id: Int
    var name: String
    var imageUrl: String?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.imageUrl = json["photo_100"].stringValue
    }
}

struct NewsfeedGroup {
    var id: Int
    var title: String
    var imageUrl: String?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["name"].stringValue
        self.imageUrl = json["photo_100"].stringValue
    }
}

final class VKNewsfeedService {
    
    // MARK: - Session
    
    let session = Session.instance
    
    // MARK: - Actions
    
    func get(complition: @escaping ([NewsfeedItem]) -> Void) {
        guard let url = URL(string:"https://api.vk.com/method/newsfeed.get?access_token=\(session.token)&v=5.81&filters=post,photo,wall_photo")
        else {
            complition([])
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("VKNewsfeedService error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    complition([])
                }
                return
            }
            let items = self?.parse(data) ?? []
            
            DispatchQueue.main.async {
                complition(items)
            }
        }
        task.resume()
    }
    
    func parse(_ data: Data?) -> [NewsfeedItem] {
        guard let data = data else { return [] }
        
        do {
            let json = try JSON(data: data)
            
            let items = json["response"]["items"]
                .arrayValue
                .map { NewsfeedItem(json: $0) }
            let profiles = json["response"]["profiles"]
                .arrayValue
                .map { NewsfeedProfile(json: $0) }
            let groups = json["response"]["groups"]
                .arrayValue
                .map { NewsfeedGroup(json: $0) }
            
            let newItems = connectItems(items, profiles: profiles, groups: groups)
            return newItems
            
        } catch  {
            print(error)
            return []
        }
    }
    
    func connectItems(_ items: [NewsfeedItem], profiles: [NewsfeedProfile], groups: [NewsfeedGroup]) -> [NewsfeedItem] {
        var newItems: [NewsfeedItem] = []
        
        for item in items {
            var newItem = item
            if item.sourceId > 0 {
                let profile = profiles
                    .filter({ item.sourceId == $0.id })
                    .first
                newItem.author = profile?.name
                newItem.authorImageUrl = profile?.imageUrl
            } else {
                let group = groups
                    .filter({ abs(item.sourceId) == $0.id })
                    .first
                newItem.author = group?.title
                newItem.authorImageUrl = group?.imageUrl
            }
            newItems.append(newItem)
        }
        return newItems
    }
}
