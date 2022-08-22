//
//  ImageViewExtension.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import UIKit

extension UIImageView {
    
    func downloadImage(url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func setImageUrl(url: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: url) else { return }
        downloadImage(url: url, contentMode: mode)
    }
}
