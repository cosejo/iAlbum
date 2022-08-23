//
//  ServerRequests.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum Endpoint: Request {
    case getPhotos(index: Int, limit: Int)
    
    var basePath: String {
        return NetworkConstants.baseURLPath
    }
    
    var baseURL: URL {
        guard let url = URL(string: basePath) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var requestURL: URL {
        return baseURL.appendingPathComponent(path, isDirectory: false)
    }
    
    var path: String {
        return NetworkConstants.getPhotosPath
    }
    
    var headers: Headers? {
        return [NetworkConstants.contentHeaderKey: NetworkConstants.applicationJSONHeaderValue]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .getPhotos(let index, let limit):
            return [NetworkConstants.startParameterKey: String(index), NetworkConstants.limitParameterKey: String(limit)]
        }
    }
    
    /**
     * Get Url Request object from the Endpoint information
     */
    func getURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        let queryParams = parameters?.map({ (key, value) in
            return URLQueryItem(name: key, value: value)
        })
        
        var components = URLComponents(string: requestURL.absoluteString)
        components?.queryItems = queryParams
        urlRequest.url = components?.url
        return urlRequest
    }
}
