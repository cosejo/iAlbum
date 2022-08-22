//
//  URLSessionProtocols.swift
//  iAlbum
//
//  Created by Carlos Osejo on 22/8/22.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol{}

extension URLSessionDataTask: URLSessionDataTaskProtocol{}
