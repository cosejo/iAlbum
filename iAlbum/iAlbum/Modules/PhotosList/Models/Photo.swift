//
//  Photo.swift
//  iAlbum
//
//  Created by Carlos Osejo on 20/8/22.
//

import Foundation

struct Photo {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

extension Photo: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
        case thumbnailUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        albumId = try container.decode(Int.self, forKey: .albumId)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(String.self, forKey: .url)
        thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
    }
}
