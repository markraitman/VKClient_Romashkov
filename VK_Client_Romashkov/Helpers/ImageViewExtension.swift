//
//  ImageViewExtension.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 09.03.2021.
//

import UIKit

extension UIImageView {
    func downloadImage(urlPath: String?) {
        guard let urlPath = urlPath,
              let url = URL(string: urlPath)
        else {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
