//
//  PhotoCell.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: DownloadableImageView!
    
    var cellReused: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellReused?()
    }
    
    func setCellInformation(url: String, cache: NSCache<AnyObject, AnyObject>?, contentMode: ContentMode = .scaleAspectFit) {
        photoImageView.contentMode = contentMode
        photoImageView.downloadImage(url, cache: cache)
    }
}
