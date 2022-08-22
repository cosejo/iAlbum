//
//  PhotosCollectionPresenter.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import Foundation

class PhotosCollectionPresenter: PhotosCollectionContractPresenter {
    
    public let photosLimit = 20
    
    public var view: PhotosCollectionContractView
    public var networkManager: NetworkManager
    public var photos: [Photo] = []
    
    init(view: PhotosCollectionContractView, networkManager: NetworkManager = IAlbumNetworkManager()) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func loadPhotos() {
        DispatchQueue.main.async {
            self.view.showLoading()
        }
        
        networkManager.getPhotos(index: photos.count, limit: photosLimit) { [weak self] newPhotos, error in
            if newPhotos == nil || error != nil {
                DispatchQueue.main.async {
                    self?.view.dismissLoading()
                    self?.view.showError()
                }
            } else {
                self?.photos.append(contentsOf: newPhotos!)
                DispatchQueue.main.async {
                    self?.view.dismissLoading()
                    self?.view.updatePhotosCollection(newPhotos: newPhotos!)
                }
            }
        }
    }
}
