//
//  PhotosCollectionViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 08.11.2020.
//

import UIKit
import RealmSwift

final class PhotosCollectionViewController: UICollectionViewController {
    
    // MARK: View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataPhotos(ownerId: friendId)
        VKservice.getPhoto(ownerId: friendId)
    }
    
    // MARK: - Web Service
    
    let VKservice = VKAPIService()
    
    // MARK: - Realm
    
    let realm = try! Realm()
    var token: NotificationToken?
    
    func loadDataPhotos(ownerId: Int){
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: config) else { return }
        
        let photos = realm.objects(Photo.self).filter("ownerId == \(ownerId)")
        
        token = photos.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial (let photos):
                self?.photos = Array(photos)
                self?.collectionView.reloadData()
            case .update(let photos, _, _, _):
                self?.photos = Array(photos)
                self?.collectionView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Properties
    
    var friendId = 0
    
    // MARK: - DataSource
    
    var photos: [Photo] = []
    
    // MARK: - Sections
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    // MARK: - Items
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    // MARK: Cell
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as! PhotoCell
        
        let chosenPhoto = photos[indexPath.item]
        
        cell.photoImageView.downloadImage(urlPath: chosenPhoto.imageURL)
        cell.photoImageView.layer.cornerRadius = 40
        cell.photoImageView.layer.masksToBounds = true
        
        return cell
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let fullScreenVC = segue.destination as? FullScreenPhotosViewController,
            let indexPath = collectionView.indexPathsForSelectedItems?.first
        else { return }

        fullScreenVC.title = title
        fullScreenVC.fullScreenPhotos = photos
        fullScreenVC.selectedPhoto = indexPath.item
    }
}
