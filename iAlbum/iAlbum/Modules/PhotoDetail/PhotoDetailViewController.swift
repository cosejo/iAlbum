//
//  PhotoDetailViewController.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    public var activityIndicator: UIActivityIndicatorView?
    public var photoUrl: String?
    public var isLoading: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        loadImage()
    }
    
    func loadImage() {
        guard let url = photoUrl else {
            return
        }
        
        photoImageView.setImageUrl(url: url)
    }
}
