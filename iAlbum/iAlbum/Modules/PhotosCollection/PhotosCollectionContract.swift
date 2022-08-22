//
//  PhotosCollectionContract.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import Foundation
    
protocol PhotosCollectionContractView {
    func showLoading()
    func dismissLoading()
    func showError()
    func updatePhotosCollection(newPhotos: [Photo], isReload: Bool)
    func openPhotoDetail(thumbnailUrl: String)
}

protocol PhotosCollectionContractPresenter {
    func loadPhotos()
    func reloadPhotos()
    func selectPhoto(_ index: Int)
}
