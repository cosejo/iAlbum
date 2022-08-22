//
//  MockNetworkManager.swift
//  iAlbumTests
//
//  Created by Carlos Osejo on 22/8/22.
//

import Foundation
@testable import iAlbum

class MockNetworkManager: NetworkManager {
    
    var result: ResponseResult
    var photosResponse: [Photo]?
    
    init(result: ResponseResult, photosResponse: [Photo]?) {
        self.result = result
        self.photosResponse = photosResponse
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
}
