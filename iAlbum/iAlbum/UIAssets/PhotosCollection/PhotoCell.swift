//
//  PhotoCell.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setCellInformation(url: String) {
        photoImageView.setImageUrl(url: url)
    }
}
