//
//  NetworkManager.swift
//  iAlbum
//
//  Created by Carlos Osejo on 20/8/22.
//

import Foundation

class IAlbumNetworkManager: NetworkManager {
    
    private var urlSession: URLSession
    private var task: URLSessionTask?
    
    init(urlSession: URLSession = URLSession.shared) {
      self.urlSession = urlSession
    }
    
    func getPhotos(index: Int, limit: Int, callback: @escaping getPhotosResponseCallback) {
        let request = Endpoint.getPhotos(index: index, limit: limit).getURLRequest()
        task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let urlResponse = response as? HTTPURLResponse {
                let result = self.handleResponse(urlResponse)
                switch result {
                case .success:
                    guard let responseData = data else {
                        callback(nil, error)
                        return
                    }
                    
                    do {
                        let photosResponse = try JSONDecoder().decode([Photo].self, from: responseData)
                        callback(photosResponse, error)
                    } catch {
                        callback(nil, error)
                    }
                    
                    break
                case .failure:
                    callback(nil, error)
                    break
                }
            }
        })
        
        task?.resume()
    }
    
    func handleResponse(_ response: HTTPURLResponse) -> ResponseResult {
        switch response.statusCode {
        case 200...299:
            return .success
        default:
            return .failure
        }
    }
}
