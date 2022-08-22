//
//  PhotosCollectionPresenter.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import Foundation

class PhotosCollectionPresenter: PhotosCollectionContractPresenter {
    
    public let photosLimit = 21
    
    public var view: PhotosCollectionContractView
    public var networkManager: NetworkManager
    public var photos: [Photo] = []
    
    init(view: PhotosCollectionContractView, networkManager: NetworkManager = IAlbumNetworkManager()) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func loadPhotos() {
        fetchPhotos(index: photos.count, limit: photosLimit)
    }
    
    func reloadPhotos() {
        let currentPhotsCount = photos.count
        photos = []
        fetchPhotos(index: 0, limit: currentPhotsCount, isReload: true)
    }
    
    func fetchPhotos(index: Int, limit: Int, isReload: Bool = false) {
        DispatchQueue.main.async {
            self.view.showLoading()
        }
        
        networkManager.getPhotos(index: index, limit: limit) { [weak self] newPhotos, error in
            if newPhotos == nil || error != nil {
                DispatchQueue.main.async {
                    self?.view.dismissLoading()
                    self?.view.showError()
                }
            } else {
                self?.photos.append(contentsOf: newPhotos!)
                DispatchQueue.main.async {
                    self?.view.dismissLoading()
                    self?.view.updatePhotosCollection(newPhotos: newPhotos!, isReload: isReload)
                }
            }
        }
    }
}
