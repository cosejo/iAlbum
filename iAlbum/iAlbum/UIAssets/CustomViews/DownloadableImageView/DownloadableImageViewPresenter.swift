//
//  DownloadableImageViewPresenter.swift
//  iAlbum
//
//  Created by Carlos Osejo on 23/8/22.
//

import Foundation

class DownloadableImageViewPresenter: DownloadableImageContractPresenter {
    
    public var view: DownloadableImageContractView
    public var networkManager: NetworkManager
    
    init(view: DownloadableImageContractView, networkManager: NetworkManager = IAlbumNetworkManager()) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func downloadImage(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        networkManager.downloadImage(url) { [weak self] data, error in
            guard let self = self,
                  let data = data else {
                return
            }
            
            self.view.showImage(data: data, url: urlString)
        }
    }
    
    func cancelLoadingImage() {
        networkManager.cancelLoadingImage()
    }
}
