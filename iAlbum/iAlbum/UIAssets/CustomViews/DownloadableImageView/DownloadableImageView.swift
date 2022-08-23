//
//  DownloadableImageView.swift
//  iAlbum
//
//  Created by Carlos Osejo on 23/8/22.
//

import UIKit

class DownloadableImageView: UIImageView {
    
    public lazy var presenter = DownloadableImageViewPresenter(view: self)
    public var imageCache: NSCache<AnyObject, AnyObject>?
    
    func downloadImage(_ url: String, cache: NSCache<AnyObject, AnyObject>?) {
        imageCache = cache
        image = nil
        
        if let cachedImage = imageCache?.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        presenter.downloadImage(url)
    }
    
    func cancelLoadingImage() {
        presenter.cancelLoadingImage()
    }
}

extension DownloadableImageView: DownloadableImageContractView {
    
    func showImage(data: Data, url: String) {
        guard let image = UIImage(data: data) else {
            return
        }
        
        DispatchQueue.main.async {
            self.image = image
        }
        
        imageCache?.setObject(image, forKey: url as AnyObject)
    }
}
