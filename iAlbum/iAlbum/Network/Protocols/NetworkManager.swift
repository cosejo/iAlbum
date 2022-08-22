//
//  NetworkManager.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import Foundation

typealias getPhotosResponseCallback = ([Photo]?, Error?) -> Void

protocol NetworkManager {
    func getPhotos(index: Int, limit: Int, callback: @escaping getPhotosResponseCallback)
    func handleResponse(_ response: HTTPURLResponse) -> ResponseResult
}
