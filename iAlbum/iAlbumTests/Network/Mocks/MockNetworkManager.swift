//
//  MockNetworkManager.swift
//  iAlbumTests
//
//  Created by Carlos Osejo on 22/8/22.
//

import Foundation
@testable import iAlbum

class MockNetworkManager: NetworkManager {
    
    public var result: ResponseResult
    public var photosResponse: [Photo]?
    public var data: Data?
    public var isLoadingCancelled = false
    
    init(result: ResponseResult, photosResponse: [Photo]? = nil, data: Data? = nil) {
        self.result = result
        self.photosResponse = photosResponse
        self.data = data
    }
    
    func getPhotos(index: Int, limit: Int, callback: @escaping getPhotosResponseCallback) {
        switch handleResponse(HTTPURLResponse()) {
        case .success:
            callback(photosResponse, nil)
            break
        case .failure:
            callback(nil, nil)
            break
        }
    }
    
    func handleResponse(_ response: HTTPURLResponse) -> ResponseResult {
        return result
    }
    
    func downloadImage(_ url: URL, callback: @escaping downloadImageResponseCallback) {
        switch handleResponse(HTTPURLResponse()) {
        case .success:
            callback(data, nil)
            break
        case .failure:
            callback(nil, nil)
            break
        }
    }
    
    func cancelLoadingImage() {
        isLoadingCancelled = true
    }
}
