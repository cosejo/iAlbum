//
//  NetworkConstants.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import Foundation

enum NetworkConstants {
    static let baseURLPath = "https://jsonplaceholder.typicode.com/"
    static let getPhotosPath = "photos"
    static let contentHeaderKey = "Content-Type"
    static let applicationJSONHeaderValue = "application/json"
    static let startParameterKey = "_start"
    static let limitParameterKey = "_limit"
    static let imageMimeType = "image/"
    static let successfulResponseCode = 200
}
