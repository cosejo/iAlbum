//
//  PhotoDetailViewController.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: DownloadableImageView!
    
    public var activityIndicator: UIActivityIndicatorView?
    public var photoUrl: String?
    
    //Mark: Lifecycle
    override func viewDidLoad() {
        loadImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        photoImageView.cancelLoadingImage()
    }
    
    //Mark: Methods
    func loadImage() {
        guard let url = photoUrl else {
            return
        }
        
        photoImageView.downloadImage(url, cache: nil)
    }
}
