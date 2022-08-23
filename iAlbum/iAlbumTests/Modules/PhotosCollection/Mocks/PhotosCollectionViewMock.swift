//
//  PhotosCollectionViewMock.swift
//  iAlbumTests
//
//  Created by Carlos Osejo on 22/8/22.
//

import Foundation
@testable import iAlbum

class PhotosCollectionViewMock: PhotosCollectionContractView {
    
    private(set) var photos: [Photo] = []
    private(set) var isLoading = false
    private(set) var isErrorShown = false
    private(set) var isReload = false
    private(set) var isDetailOpen = false
    private(set) var thumbnailUrl = ""
    
    func showLoading() {
        isLoading = true
    }
    
    func dismissLoading() {
        isLoading = false
    }
    
    func showError() {
        isErrorShown = true
    }
    
    /**
     * Replicate some of the logic in order to test how change the photos collection
     */
    func updatePhotosCollection(newPhotos: [Photo], isReload: Bool) {
        self.isReload = isReload
        if isReload {
            photos = newPhotos
        } else {
            photos.append(contentsOf: newPhotos)
        }
    }
    
    func openPhotoDetail(thumbnailUrl: String) {
        isDetailOpen = true
        self.thumbnailUrl = thumbnailUrl
    }
}
