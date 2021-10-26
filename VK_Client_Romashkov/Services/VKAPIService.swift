//
//  VKAPIService.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 05.03.2021.
//

import UIKit
import Alamofire
import RealmSwift

class VKAPIService {
    
    // MARK: - Session
    
    let session = Session.instance
    
    // MARK: - URL
    
    let baseUrl = "https://api.vk.com/method"
    
    // MARK: - Authorization
    
    static func getVKAuthorization() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7557260"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "2703421"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        return URLRequest(url: components.url!)
    }
    
    // MARK: - Friends
    
    func getFriends(completion: (([User]) -> Void)? = nil) {
        let methodUrl = "/friends.get"
        let url = baseUrl + methodUrl
        let parameters: Parameters = [
            "user_ids" : "\(Session.instance.userId)",
            "access_token" : Session.instance.token,
            "fields" : "photo_100",
            "v" : "5.68"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] (response) in
            guard let data = response.data else { return }
            do {
                let friendsResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                self?.saveFriendsData(friendsResponse.response.items)
                completion?(friendsResponse.response.items)
            }
            catch {
                completion?([])
            }
        }
    }
    
    func saveFriendsData(_ friends: [User]) {
        do {
            let realm = try Realm()
            let oldValues = realm.objects(User.self)
            realm.beginWrite()
            realm.delete(oldValues)
            realm.add(friends, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    // MARK: - Photo
    
    func getPhoto(ownerId: Int, completion: (([Photo]) -> Void)? = nil) {
        let methodUrl = "/photos.getAll"
        let url = baseUrl + methodUrl
        let parameters: Parameters = [
            "user_ids" : "\(Session.instance.userId)",
            "access_token" : Session.instance.token,
            "owner_id" : "\(ownerId)",
            "photo_sizes" : "1",
            "count" : "200",
            "v" : "5.68"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] (response) in
            guard let data = response.data else { return }
            do {
                let photos = try JSONDecoder().decode(PhotoResponse.self, from: data)
                self?.savePhotosData(photos.response.items)
                completion?(photos.response.items)
            }
            catch {
                completion?([])
            }
        }
    }
    
    func savePhotosData(_ photos: [Photo]) {
        do {
            let realm = try Realm()
            let oldValues = realm.objects(Photo.self)
            realm.beginWrite()
            realm.delete(oldValues)
            realm.add(photos, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Group
    
    func getGroups(completion: (([Group]) -> Void)? = nil) {
        let methodUrl = "/groups.get"
        let url = baseUrl + methodUrl
        let parameters: Parameters = [
            "user_ids" : "\(Session.instance.userId)",
            "access_token" : Session.instance.token,
            "extended" : "1",
            "fields" : "photo_100",
            "v" : "5.68"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] (response) in
            guard let data = response.data else { return }
            do {
                let groups = try JSONDecoder().decode(GroupResponse.self, from: data)
                self?.saveGroupsData(groups.response.items)
                completion?(groups.response.items)
            }
            catch {
                completion?([])
            }
        }
    }
    
    func saveGroupsData(_ groups: [Group]) {
        do {
            let realm = try Realm()
            let oldValues = realm.objects(Group.self)
            realm.beginWrite()
            realm.delete(oldValues)
            realm.add(groups, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Group Search
    
    func groupSearch(searchText: String, completion: @escaping ([Group]) -> Void) {
        let methodUrl = "/groups.search"
        let url = baseUrl + methodUrl
        let parameters: Parameters = [
            "user_ids" : "\(Session.instance.userId)",
            "access_token" : Session.instance.token,
            "extended" : "1",
            "fields" : "photo_100",
            "q" : searchText.lowercased(),
            "v" : "5.68"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
            guard let data = response.data else { return }
            do {
                let searchGroups = try JSONDecoder().decode(GroupResponse.self, from: data)
                completion(searchGroups.response.items)
            }
            catch {
                completion([])
            }
        }
    }
}
