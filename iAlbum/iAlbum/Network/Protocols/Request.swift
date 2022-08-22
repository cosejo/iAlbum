//
//  Request.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import Foundation

typealias Parameters = [String : String]
typealias Headers = [String : String]

protocol Request {
    var basePath: String { get}
    var baseURL: URL { get }
    var requestURL: URL { get }
    var path: String { get }
    var headers: Headers? { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}
